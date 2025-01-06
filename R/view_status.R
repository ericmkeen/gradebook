#' View status of submissions, grading, and anything missing.
#'
#' @param course_id Course ID.
#' @param assignment_id Optionally specify a single assignment.
#'
#' @return A dataframe of students, assignments, and their `graded` status (`TRUE` or `FALSE`).
#' @export
#'
view_status <- function(course_id,
                         assignment_id = NULL,
                         return_only = NULL){

  if(FALSE){
    course_id <- 'ENST_101'
    course_id <- 'ESCI_220'
    assignment_id <- NULL
    return_only = 'graded'
    # return can be 'graded', 'ungraded'
  }

  # Get students
  (students <- view_students(course_id))

  # Get assignments
  (assignments <- view_assignments(course_id))

  # Get grades
  (grades <- view_grades(course_id))

  # Initiate master dataframe
  mr <- data.frame()
  i=j=1
  for(i in 1:nrow(assignments)){
    (assi <- assignments[i,])
    for(j in 1:nrow(students)){
      (studj <- students[j,])
      studj$notes <- NULL
      (mri <- data.frame(assi, studj))
      mr <- rbind(mr, mri)
    }
  }
  mr

  # Join grades to it
  if(nrow(grades)>0){
    grades %>%
    select(course, assignment_category, assignment_id, goes_by:grade_path) ->
    grades_simple
    grades_simple
    (suppressMessages({mrs <- dplyr::left_join(mr, grades_simple)}))

    # Make a column for all ungraded assignments
    mrs$graded <- FALSE
    mrs$graded[!is.na(mrs$date_graded)] <- TRUE
    mrs

  }else{
    mrs <- mr
  }

  return(mrs)
}
