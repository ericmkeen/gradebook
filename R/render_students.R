#' A wrapper for `render_student()`.
#'
#' Loop through each student and print out a grade report for them.
#'
#' @param course_id Course ID
#' @param gg_height Height of the `ggplot2` output, in inches.
#' @param to_file Boolean; if `TRUE`, the report will be saved to the class's folder structure (course > reports > students)

#' @return desc
#' @export
#'
render_students <- function(course_id,
                            gg_height = 10,
                            to_file = TRUE){

  if(FALSE){ #=======================
    course_id <- 'ENST_209'
    to_file <- FALSE
    gg_height = 12
  }  #===============================

  (mr <- view_students(course_id))
  (studs <- sort(unique(mr$goes_by)))

  for(i in 1:length(studs)){
    studi <- studs[i]
    message('Rendering semester report for ', studi,' . . . ')
    render_student(course_id = course_id,
                   goes_by = studi,
                   gg_height = gg_height,
                   to_file = to_file)
  }

  message('')
  message('Finished!')

}
