#' Render reports for a bunch of grades
#' This function is a wrapper for `grade_render()`.
#'
#' @param course_id Course ID.
#' @param assignment_id Assignment ID.
#' @param wrap_rubric Character width of rendered rubric lines before wrapping.
#' @param wrap_notes Character width of rendered lines of written feedback notes before wrapping.
#' @param render_ratio The height ratio of the rendered file's rubric section compared to the feedback section.
#' The default is that the former section is 2.25x as tall as the latter.
#' @param pdf_height The height of the PDF file. If left `NULL`, this will be estimated automatically.
#'
#' @return Updates grade file and grade report for all matching grades.
#' @export
#'
render_grades <- function(course_id,
                          assignment_id = NULL,
                          wrap_rubric = 30,
                          wrap_notes = 100,
                          render_ratio = 2.25,
                          pdf_height = NULL){

  if(FALSE){
    assignment_id <- '#1 Carbon emissions'
    assignment_id <- 'Pre-proposal submission'
    wrap_rubric = 30
    wrap_notes = 100
    render_ratio = 2.25
    pdf_height = NULL
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
      render_grade(gradi,
                   wrap_rubric = wrap_rubric,
                   wrap_notes = wrap_notes,
                   render_ratio = render_ratio,
                   pdf_height = pdf_height)
      message(i, ' :: ' , gradi)
    }
  })

}
