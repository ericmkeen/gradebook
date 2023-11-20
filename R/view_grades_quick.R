#' Quick version of `view_grades()`
#'
#' This function returns the grades recorded for a given course (and optionally a specified assignment).
#' Unlike `view_grades()`, no details on the grades are returned. This allows the function to be very quick.
#'
#' @param course_id Course ID.
#' @param assignment_id Optionally specify a single assignment.
#'
#' @return A `data.frame`.
#' @export
#' @import dplyr
#'
view_grades_quick <- function(course_id,
                        assignment_id = NULL){

  if(FALSE){
    course_id <- 'ESCI_220'
    assignment_id <- NULL
  }

  # Get students
  (students <- view_students(course_id) %>% select(goes_by))

  # Get list of grades
  (gpath <- paste0(course_id,'/grades/'))
  (grade_files <- dir(gpath))

  (grade_splits <- stringr::str_split(gsub('.RData','',grade_files), ' --- '))
  (grades_df <-
    data.frame(course_id = lapply(grade_splits,'[[', 1) %>% unlist,
               assignment_category = lapply(grade_splits,'[[', 2) %>% unlist,
               assignment_id = lapply(grade_splits,'[[', 3) %>% unlist,
               goes_by = lapply(grade_splits,'[[', 4) %>% unlist))

  assi <- assignment_id

  if(!is.null(assignment_id)){
    grades_df <-
      grades_df %>%
      filter(assignment_id %in% assi)
  }

  grades_df

  return(grades_df)
}
