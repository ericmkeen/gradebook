#' Render reports for a bunch of grades
#' This function is a wrapper for `grade_render()`.
#'
#' @param course_id Course ID.
#' @param assignment_id Assignment ID.
#'
#' @return Updates grade file and grade report for all matching grades.
#' @export
#'
render_grades <- function(course_id, assignment_id = NULL){

  if(FALSE){
    assignment_id <- '#1 Carbon emissions'
  }

  (grade_dir <- paste0(course_id, '/grades/'))
  (grades <- dir(grade_dir))
  (grades <- paste0(grade_dir, grades))

  # Filter to assignment ID
  if(!is.null(assignment_id)){
    grades <- grades[grepl(assignment_id, grades)]
  }

  grades
  suppressWarnings({
    i=1
    for(i in 1:length(grades)){
      (gradi <- grades[i])
      render_grade(gradi)
      message(i, ' :: ' , gradi)
    }
  })

}
