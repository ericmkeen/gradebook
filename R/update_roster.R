#' Update student roster for a course
#'
#' @param course_id Course ID
#'
#' @param students_url URL to a GoogleSheet (with sharing settings set to "Anyone with the Link") with the roster.
#' This spreadsheet must have these columns: `goes_by` (the name the student goes by),
#' `first` (first name), `last` (last name), `email` (full email address) (other columns are fine and will be kept).
#'
#' @param verbose Boolean; print updates to console?
#'
#' @return A `students.rds` file saved to the course subfolder.
#' @export
#'
update_roster <- function(course_id,
                          students_url,
                          verbose = TRUE){

  if(FALSE){ # dev/debugging only
    course_id <- 'ESCI_220'
    students_url <- 'https://docs.google.com/spreadsheets/d/1otjd7iItkm9wvexXxQNQxppvOmMEagc4NchcQilzsY4/edit?usp=sharing'
  }

  # Load GoogleSheet of roster
  suppressMessages({
    students <- gsheet::gsheet2tbl(students_url)
  })

  if(verbose){
    print(students)
  }

  # Save as RDS object
  roster_file <- paste0(course_id,'/students.rds')
  save(students, file=roster_file)

}
