#' Render grades for entire class
#'
#' @param course_id  Course ID
#'
#' @return A list.
#' @export
#' @import dplyr
#' @import ggplot2
#' @import ggpubr
#'
render_class <- function(course_id){

  if(FALSE){ #=======================
    course_id <- 'ENST_209'
  }  #=======================

  (mr <- view_status(course_id))

  # Filter to non-exempt grades and/or grades already due
  (mrs <-
    mr %>%
    filter(exemption == FALSE) %>%
    filter(graded == TRUE | all(c(!is.na(already_due), already_due == TRUE))))

  # If a grade is missing (due date is past but no grade, change to 0)
  mrs$percent[is.na(mrs$percent)] <- 0
  mrs$points[is.na(mrs$points)] <- 0

  # Group by student and calculate final grade
  studs <-
    mrs %>%
    group_by(goes_by) %>%
    arrange(due_date) %>%
    mutate(total_possible = cumsum(out_of)) %>%
    mutate(total_earned = cumsum(points)) %>%
    mutate(total_percent = 100*round((total_earned / total_possible),4))

  # Get final grades
  (grades <-
    studs %>%
    group_by(student = goes_by) %>%
    summarize(last_name = last[1],
              grades_available = n(),
              points_possible = max(total_possible),
              points_earned = max(total_earned)) %>%
    mutate(current_grade = round(100*(points_earned / points_possible),2)))

  p <-
    ggplot(grades) +
    geom_segment(mapping=aes(y = student, yend = student,
                           x = 0, xend = current_grade),
               color='darkblue',
               alpha=.5,
               lwd=1.5) +
    geom_point(mapping=aes(y=student,
                         x=current_grade),
             color='darkblue',
             alpha=.7,
             size=2) +
    geom_text(mapping=aes(y=student,
                          x=current_grade,
                          label = round(current_grade,1)),
              nudge_x=3) +
    ylab(NULL) +
    xlab('Current grade') +
    scale_x_continuous(breaks=seq(0, 100, by=10), limits=c(0, 100)) +
    labs(title = paste0(gsub('_',' ',course_id), ': grade distribution'))

  returned <- list(grades = grades,
                   plot = p)

  return(returned)

}
