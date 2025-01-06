#' View missing quick
#'
#' This function returns the missing (not-yet-submitted) assignments for a given course (and optionally a specified assignment).
#' Unlike `view_missing()`, no details on the assignments are returned. This allows the function to be very quick.
#'
#' @param course_id Course ID.
#' @param assignment_id Optionally specify a single assignment.
#'
#' @return A `data.frame`.
#' @export
#' @import dplyr
#'
view_missing_quick <- function(course_id,
                              assignment_id = NULL){

  if(FALSE){
    course_id <- 'ENST_222'
    assignment_id <- 'Chapter 1 Loomings'
    view_missing_quick(course_id, assignment_id)
    view_missing_quick('ENST_101')
    view_missing_quick('ENST_209')
    missings <- view_missing_quick('ESCI_220')
    paste(missings$goes_by, collapse='\n')
  }

  assi <- assignment_id

  # Get students
  (students <- view_students(course_id)$goes_by)

  # Get all assignments
  (asses <- view_assignments(course_id)$assignment_id)

  # Get list of all potential combinations of students and assignments
  (full_list <-
      data.frame(goes_by = rep(students, times=length(asses)),
                 assignment_id = rep(asses, each=length(students))))

  # View grades quick
  (grades <-
      view_grades_quick(course_id) %>%
      select(assignment_id, goes_by) %>%
      mutate(graded = TRUE))

  (results <- left_join(full_list, grades))

  if(!is.null(assignment_id)){
    results <-
      results %>%
      filter(assignment_id %in% assi)
  }

  results

  # Filter down to ungraded assignments
  results <-
    results %>%
    filter(is.na(graded)==TRUE) %>%
    mutate(graded = FALSE)

  results

  return(results)
}
