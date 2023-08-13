#' Quick access to all grades for a course
#'
#' @param course_id Course ID.
#'
#' @return A character vector of assignment `.rds` files for the course.
#' @export
#'
view_grades <- function(course_id){

  grade_df <- data.frame()

  (gpath <- paste0(course_id,'/grades/'))
  (grades <- dir(gpath))
  if(length(grades)>0){
  (gpaths <- paste0(gpath, grades))
  i=1
  for(i in 1:length(gpaths)){
    (gi_path <- gpaths[i])
    gi <- readRDS(gi_path)
    (gi_df <- data.frame(course = course_id,
                        assignment_category = gi$assignment$assignment_category,
                        assignment_id = gi$assignment$assignment_id,
                        due_date = gi$assignment$due_date,
                        out_of = gi$assignment$out_of,
                        extra_credit = gi$assignment$extra_credit,
                        goes_by = gi$student$goes_by,
                        email = gi$student$email,
                        shared = gi$shared,
                        date_graded = gi$date_graded,
                        percent = gi$percent,
                        points = gi$points,
                        exemption = gi$exemption,
                        grade_path = gi_path))
    grade_df
    grade_df <- rbind(grade_df, gi_df)
  }

  grade_df
  }


  return(grade_df)
}
