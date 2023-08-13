#' View a list of assignments & their status for a course
#'
#' @param course_id Course ID.
#'
#' @return A dataframe with one row per assignment.
#' @export
#'
view_assignments <- function(course_id){

  if(FALSE){
    course_id <- 'ESCI_220'
  }

  ass_dir <- paste0(course_id,'/assignments/')
  (asses <- dir(ass_dir))
  (ass_paths <- paste0(ass_dir, asses))

  i=1
  ass_df <- data.frame()
  for(i in 1:length(ass_paths)){
    (assi_path <- ass_paths[i])
    (assi <- readRDS(assi_path))
    assi_df <- data.frame(course = course_id,
                          assignment_category = assi$assignment_category,
                          assignment_id = assi$assignment_id,
                          out_of = assi$out_of,
                          due_date = lubridate::date(assi$due_date),
                          extra_credit = assi$extra_credit,
                          share = assi$share
    )
    assi_df
    assi_df$already_due <- assi_df$due_date <= lubridate::date(Sys.time())
    assi_df
    ass_df <- rbind(ass_df, assi_df)
  }

  ass_df

  return(ass_df)
}
