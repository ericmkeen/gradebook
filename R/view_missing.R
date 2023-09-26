#' View missing grades
#'
#' If a student does not have a grade for an assignment that was already due, it is a missing grade.
#'
#' @param course_id Course ID.
#' @param mode How much info to provide? The `"simple"` mode just provides the essential info; the `"complete"` mode returns all information.
#' @param verbose Print updates to console?
#'
#' @return A dataframe.
#' @export
#'
view_missing <- function(course_id,
                         mode = 'complete',
                         verbose = FALSE){

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

  #if(nrow(df)==0){df <- data.frame()}
  #df
  #return(df)

  # Returns
  if(nrow(df)==0){
    if(verbose){message('No grades missing!')}
    return(df)
  }else{
    if(verbose){message('Found ', nrow(df),' missing grades:\n')}
    if(mode == 'complete'){
      return(df)
    }else{
      dfsim <- df %>% select(course, assignment_id, due_date, goes_by)
      return(dfsim)
    }
  }
}
