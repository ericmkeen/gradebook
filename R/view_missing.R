#' View missing grades
#'
#' If a student does not have a grade for an assignment that was already due, it is a missing grade.
#'
#' @param course_id Course ID.
#'
#' @return A dataframe.
#' @export
#'
view_missing <- function(course_id){

  if(FALSE){
    course_id <- 'ESCI_220'
  }

  # Get course status
  (mrs <- view_status(course_id))

  df <- data.frame()
  if(nrow(mrs)>0){
    df <-
      mrs %>%
      dplyr::filter(already_due == TRUE,
                    graded == FALSE)

  }
  if(nrow(df)==0){df <- data.frame()}
  df
  return(df)
}
