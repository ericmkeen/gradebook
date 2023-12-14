#' Render grades for entire class
#'
#' @param course_id  Course ID
#' @param drop_lowest Optional; if there are `assignment_category`'s for which you want to drop the lowest grade for each student,
#' provide those categories here as a character vector.
#' @param apply_curve Optional; adjust the entire class's grades by a percentage point that you can specify here.
#' @param letter_key  Optional; include a key for translating a percentage to a letter grade.
#' For required format, see `data(letter_grade_key)`; you can also type `"default"`, and the function
#' will load `data(letter_grade_key)` for you and use it.
#'
#' @return A list.
#' @export
#' @import dplyr
#' @import ggplot2
#' @import ggpubr
#'
render_class <- function(course_id,
                         drop_lowest = NULL,
                         apply_curve = 0,
                         letter_key = NULL){

  if(FALSE){ #=======================
    setwd("/Users/ekezell/Library/CloudStorage/GoogleDrive-ekezell@sewanee.edu/My Drive/grades/2023 fall")
    course_id <- 'ESCI_220'
    view_assignments(course_id)
    apply_curve = 0
    apply_curve = 10
    drop_lowest = NULL
    letter_key = NULL
    drop_lowest <- c('Reading quiz')
    render_class('ENST_209')
    render_class('ENST_209', c('Reading quiz'))
    render_class('ESCI_220')
    render_class('ESCI_220', apply_curve = 10)

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

  # identifier
  mrs$i <- 1:nrow(mrs)

  # Deal with drop_lowest ======================================================
  if(!is.null(drop_lowest)){
    i_to_drop <-
      mrs %>%
      filter(assignment_category %in% drop_lowest) %>%
      group_by(goes_by, assignment_category) %>%
      mutate(lowest = min(percent, na.rm=TRUE)) %>%
      mutate(highest = max(percent, na.rm=TRUE)) %>%
      mutate(high_test = lowest == highest) %>%
      mutate(i_drop = tail(i[percent == lowest], 1)) %>%
      mutate(i_drop = ifelse(high_test, NA, i_drop)) %>%
      summarize(lowest = lowest[1],
                high_test = high_test[1],
                i_drop = tail(i_drop, 1)) %>%
      filter(!is.na(i_drop)) %>%
      pull(i_drop)

    i_to_drop

    if(length(i_to_drop)>0){
      nrow(mrs)
      mrs <- mrs %>% filter(! i %in% i_to_drop)
      nrow(mrs)
    }

    mrs <- mrs %>% select(-i)
  } # ==========================================================================

  # Group by student and calculate final grade
  studs <-
    mrs %>%
    group_by(goes_by) %>%
    arrange(due_date) %>%
    mutate(total_possible = cumsum(out_of)) %>%
    mutate(total_earned = cumsum(points)) %>%
    mutate(total_percent = 100*round((total_earned / total_possible),4))

  # ============================================================================
  # Get final grades
  (grades <-
    studs %>%
    group_by(student = goes_by) %>%
    summarize(last_name = last[1],
              grades_available = n(),
              points_possible = max(total_possible),
              points_earned = max(total_earned)) %>%
    mutate(current_grade = round(100*(points_earned / points_possible),2)) %>%
    # apply curve to final percent
    mutate(current_grade = current_grade + apply_curve))

  # Include letter grade key?
  if(!is.null(letter_key)){
    if(letter_key == 'default'){
      data(letter_grade_key)
    }else{
      letter_grade_key <- letter_key
    }

    x <- 93
    letters <- sapply(grades$current_grade, function(x){
      (letti <- which(letter_grade_key$grade_floor <= round(x)))
      letter_grade_key[letti,]
      x_letter <- letter_grade_key$letter_detail[letti[1]]
      return(x_letter)
    })

    grades$letter <- letters
    grades
  }

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
              nudge_x=5) +
    ylab(NULL) +
    xlab('Current grade') +
    scale_x_continuous(breaks=seq(0, 100, by=10), limits=c(0, 105)) +
    labs(title = paste0(gsub('_',' ',course_id), ': grade distribution'))

  returned <- list(grades = data.frame(grades),
                   plot = p)

  return(returned)

}
