#' Setup a subfolder for a course
#'
#' Creates the course subfolder within your working directory.
#' This function will not replace any existing folders or files.
#'
#' @param course_id Character vector of ID for your course, e.g., "ENST_320"
#'
#' @return desc
#' @export
#'
setup_course <- function(course_id){

  if(FALSE){ #==================================================================
    course_id <- 'ENST_320'
  } #===========================================================================

  # Create course subfolder in wd
  if(!dir.exists(course_id)){
    dir.create(course_id)
  }

  # make sure www folder exists
  sub_ass <- paste0('www')
  if(!dir.exists(sub_ass)){
    dir.create(sub_ass)
  }

  # Within course folder, make subfolders
  sub_ass <- paste0(course_id, '/assignments')
  if(!dir.exists(sub_ass)){
    dir.create(sub_ass)
  }

  sub_grades <- paste0(course_id, '/grades')
  if(!dir.exists(sub_grades)){
    dir.create(sub_grades)
  }

  sub_grades <- paste0(course_id, '/rubrics')
  if(!dir.exists(sub_grades)){
    dir.create(sub_grades)
  }

  sub_grades <- paste0(course_id, '/reports')
  if(!dir.exists(sub_grades)){
    dir.create(sub_grades)
  }

  sub_grades <- paste0(course_id, '/reports/grades')
  if(!dir.exists(sub_grades)){
    dir.create(sub_grades)
  }

  sub_grades <- paste0(course_id, '/reports/students')
  if(!dir.exists(sub_grades)){
    dir.create(sub_grades)
  }

  sub_grades <- paste0(course_id, '/reports/class')
  if(!dir.exists(sub_grades)){
    dir.create(sub_grades)
  }

  # Setup R file for staging assignments
  setup_file <- paste0(course_id, '/setup_', course_id, '.R')
  if(!file.exists(setup_file)){
    file.create(setup_file)
  }

  # Add demo text to setup.R file
  cat('#####################################\n# Setup course assignments here\n#####################################',
      file=setup_file, append=TRUE)

  cat('\n\n# Demo assignment\nassignment()\n\n# Under construction!',
      file=setup_file, append=TRUE)


}
