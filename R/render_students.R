#' A wrapper for `render_student()`.
#'
#' Loop through each student and print out a grade report for them.
#'
#' @param course_id Course ID
#' @param drop_lowest Optional; if there are `assignment_category`'s for which you want to drop the lowest grade for each student,
#' provide those categories here as a character vector.
#' @param gg_height Height of the `ggplot2` output, in inches.
#' @param to_file Boolean; if `TRUE`, the report will be saved to the class's folder structure (course > reports > students)

#' @return desc
#' @export
#'
render_students <- function(course_id,
                            drop_lowest = NULL,
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
                   drop_lowest = drop_lowest,
                   goes_by = studi,
                   gg_height = gg_height,
                   to_file = to_file)
  }

  message('')
  message('Finished!')

}
