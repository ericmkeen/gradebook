email_status <- function(course_id = NULL,
                         verbose=TRUE){

  if(FALSE){ #=============================
    email_status()
  } #======================================

  # Get list of courses
  (courses <- list.dirs('.', recursive=FALSE))
  (courses <- gsub('./', '', courses))
  (courses <- courses[! courses %in% c('.git', '.Rproj.user', 'man', 'R')])

  # Filter by input
  if(!is.null(course_id)){
    courses <- courses[courses %in% course_id]
  }

  # Get list of unshared grades
  unshared_grades <- c()
  if(length(courses)>0){
    ci=1
    for(ci in 1:length(courses)){
      (coursi <- courses[ci])
      (grades <- dir(paste0(coursi,'/grades/')))
      if(length(grades)>0){
        gi = 1
        for(gi in 1:length(grades)){
          (gradi <- grades[gi])
          (gradi <- paste0(coursi,'/grades/',gradi))
          (grade <- readRDS(gradi))
          if(grade$shared == FALSE){
            unshared_grades <- c(unshared_grades, gradi)
          }
        }
      }
    }

    # Returns
    if(length(unshared_grades)==0){
      if(verbose){message('All grades have been shared!')}
    }else{
      if(verbose){message('Found ',length(unshared_grades),' unshared grades:\n')}
      return(unshared_grades)
    }
  }else{
    if(verbose){message('No course found.')}
  }
}
