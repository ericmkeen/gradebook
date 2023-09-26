#' View which grades have not yet been emailed to students
#'
#' @param course_id Course ID.
#' @param mode How much info to provide? The `"simple"` mode just provides the essential info; the `"complete"` mode returns all information.
#' @param verbose Print updates to console?
#'
#' @return A vector of grade files that have not yet been shared over email.
#' @export
#'
view_unshared <- function(course_id,
                          mode = 'simple',
                          verbose=TRUE){

  if(FALSE){ #=============================
    email_status()
  } #======================================

  # Get course status
  df <- data.frame()
  (mrs <- view_status(course_id))
  if(nrow(mrs)>0){
    df <- mrs %>% dplyr::filter(already_due == TRUE | graded == TRUE,
                        share == TRUE,
                        shared == FALSE)
    if(nrow(df)==0){df <- data.frame()}
  }
  df

  # Returns
  if(nrow(df)==0){
    if(verbose){message('All grades have been shared!')}
  }else{
    if(verbose){message('Found ', nrow(df),' unshared grades:\n')}
    if(mode == 'complete'){
      return(df)
    }else{
      dfsim <- df %>% select(course, assignment_id, due_date, goes_by)
      return(dfsim)
    }
  }
  #return(df)
}
