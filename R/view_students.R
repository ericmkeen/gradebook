#' Quick look at student roster for a course
#'
#' @param course_id Course ID
#'
#' @return Returns a `data.frame` of the student roster.
#' @export
#'
view_students <- function(course_id){
  # quick look at student list

  if(FALSE){ # dev/debugging only
    course_id <- 'ESCI_220'
  }

  (student_file <- paste0(course_id,'/students.rds'))

  load(student_file)
  students

  return(students)
}
