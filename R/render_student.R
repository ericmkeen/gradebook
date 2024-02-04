#' Render grade report for a student
#'
#' @param course_id Course ID
#' @param goes_by Student name (goes_by column)
#' @param drop_lowest Optional; if there are `assignment_category`'s for which you want to drop the lowest grade for each student,
#' provide those categories here as a character vector.
#' @param anonymize A Boolean that lets you replace the student's name with a randomized set of numbers, for confidentiality purposes.
#' @param gg_height Height of the `ggplot2` output, in inches.
#' @param to_file Boolean; if `TRUE`, the report will be saved to the class's folder structure (course > reports > students)
#'
#' @return A list.
#' @export
#' @import dplyr
#' @import ggplot2
#' @import ggpubr

render_student <- function(course_id,
                           goes_by,
                           drop_lowest = NULL,
                           anonymize = FALSE,
                           gg_height = 10,
                           to_file = FALSE){

  if(FALSE){ #=======================
    course_id <- 'ENST_209'
    goes_by <- 'Zach'
    to_file <- FALSE
    gg_height = 12
    drop_lowest = NULL
    anonymize = TRUE
    drop_lowest = 'Reading quiz'

    render_student(course_id, goes_by, drop_lowest)

    df <- render_student('ENST_209',
                   'Betsy',
                   #drop_lowest = NULL
                   #drop_lowest = 'Reading quiz'
                   drop_lowest = 'Film response'
                   )
    df$render

    render_student('ENST_209', 'Alex', anonymize = TRUE)
  }  #===============================

  # Get class data
  (mr <- view_status(course_id))
  stud <- goes_by
  rm(goes_by)

  # Filter to student
  (mrs <- mr %>% filter(goes_by == stud))

  # Filter to rows with a grade or that should already be graded based on due date
  (mrs <- mrs[which(mrs$graded | all(c(!is.na(mrs$already_due), mr$already_due==TRUE))),])

  # If a grade is missing (due date is past but no grade, change to 0)
  mrs$percent[is.na(mrs$percent)] <- 0
  mrs$points[is.na(mrs$points)] <- 0

  # Deal with drop_lowest (just convert to exemption = TRUE)
  if(!is.null(drop_lowest)){
    mrs <- drop_lowest_grade(mrs, drop_lowest)
  }

  # Arrange by due date
  mrs <- mrs %>% arrange(due_date)

  # Get exemptions
  (exemptions <- paste(mrs %>% filter(exemption == TRUE) %>% pull(assignment_id),
                       collapse = ', '))
  message('Exemptions: ', exemptions)

  # Remove exemptions
  (mrs <- mrs %>% filter(exemption == FALSE))

  # Add points possible column
  mrs$total_possible <- cumsum(mrs$out_of)
  mrs$total_earned <- cumsum(mrs$points)
  mrs$total_percent <- round(100*(mrs$total_earned / mrs$total_possible),1)

  # View
  mrs

  # Plot 1: Percents for each grade, arranged chronologically
  a <-
    ggplot(mrs %>% mutate(rank = n():1)) +
    geom_point(mapping = aes(y=rank,
                             x=percent), color='firebrick', alpha=.7) +
    geom_segment(mapping = aes(y=rank, yend=rank,
                             x=0, xend=percent), color='firebrick', alpha=.7) +
    geom_vline(xintercept = mrs$total_percent[nrow(mrs)], lty=2, color='darkblue', alpha=.7) +
    scale_x_continuous(limits=c(0,max(c(100, max(ceiling(mrs$percent))))), breaks=seq(0,100,by=10)) +
    scale_y_continuous(breaks = 1:nrow(mrs),  labels = rev(mrs$assignment_id)) +
    ylab(NULL) + xlab('Assignment grade') +
    labs(title=paste0('All grades on record'))

  if(nchar(exemptions)>4){
    a <- a + labs(caption = paste0('Exemptions applied to: ', exemptions))
  }

  a

  # Plot 2: Cumulative points earned
  b <-
    ggplot(mrs) +
    geom_point(mapping = aes(x=due_date, y=total_possible), color='darkblue', alpha=.5) +
    geom_path(mapping = aes(x=due_date, y=total_possible), lty=2, color='darkblue', alpha=.5) +
    geom_area(mapping = aes(x=due_date, y=total_earned), fill='firebrick', alpha=.5) +
    geom_point(mapping = aes(x=due_date, y=total_earned), color='firebrick') +
    geom_path(mapping = aes(x=due_date, y=total_earned), color='firebrick', alpha=.8, lwd=1.2) +
    xlab('Due date') +
    ylab('Points') +
    labs(title='Points possible (blue dashed lne) vs. points earned (red)')

  #b


  # Plot 3: Running percentage
  (studplot <- ifelse(anonymize == TRUE,
                      paste0('student ',sample(1000:9999, size=1, replace = FALSE)),
                      stud))
  c <-
    ggplot(mrs) +
    geom_point(mapping = aes(x=due_date, y=total_percent), color='firebrick') +
    geom_area(mapping = aes(x=due_date, y=total_percent), fill='firebrick', alpha=.5) +
    geom_path(mapping = aes(x=due_date, y=total_percent), color='firebrick', alpha=.8, lwd=1.2) +
    xlab('Due date') +
    scale_y_continuous(breaks = seq(0, 100, by=10), limits=c(0,100)) +
    geom_hline(yintercept = 100, lty=2) +
    ylab('Overall grade') +
    labs(title=paste0(studplot, ' in ', gsub('_', ' ', course_id),
                      ': current grade = ',
                      mrs$total_percent[nrow(mrs)],
                      '%'))

  #c


  rendered_report <- ggpubr::ggarrange(c, a, ncol=1, nrow=2, heights = c(1, 2))
  #rendered_report <- ggpubr::ggarrange(c, b, a, ncol=1, nrow=3, heights = c(1, 1, 2))

  df <- list(data = mrs,
             current_grade = mrs$total_percent[nrow(mrs)],
             render = rendered_report)

  if(to_file){
    # Check for directory first
    (report_dir <- paste0(course_id,'/reports/students/'))
    if(!dir.exists(report_dir)){
      dir.create(report_dir)
    }
    (fn <-   paste0(report_dir, course_id,' as of ',
                    lubridate::ymd(lubridate::date(Sys.time())),
                    ' --- ',
                    stud, '.pdf'))
    ggsave(filename = fn,
           plot = rendered_report,
           height = gg_height)
  }

  return(df)
}
