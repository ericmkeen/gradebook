#' Send grades to students over email
#'
#' @param course_id Course ID.
#' @param assignment_id Optionally specify an assignment; otherwise unsent grades from all assignments will be sent.
#' @param student_id Optionally specify a student; otherwise unsent grades for all students will be sent.
#' @param your_email Your email address.
#' @param json_path File path to your `json` credentials on your machine. This is necessary to send emails via the package `gmailr`.
#' @param verbose Print updates to console?
#'
#' @return desc
#' @export
#'
email_grades  <- function(course_id,
                          assignment_id = NULL,
                          student_id = NULL,
                          your_email = 'ekezell@sewanee.edu',
                          unshared_only = TRUE,
                          json_path = FALSE,
                          verbose=TRUE){

  if(FALSE){ #=============================
    course_id <- 'ENST_101'
    assignment_id <- NULL
    student_id <- NULL
    unshared_only <- TRUE
    verbose=TRUE
    your_email = 'ekezell@sewanee.edu'
    json_path = '/Users/ekezell/repos/credentials/desktop_gradebook.json'
    #email_grades(json_path = json_path)

  } #======================================

  if(unshared_only){
    # Get unshared grades
    (unshared <- view_unshared(course_id = course_id, verbose=FALSE))
    if(verbose){base::message('Total unshared grades = ',nrow(unshared))}
  }else{
    unshared <- view_status(course_id)
    if(verbose){base::message('Total grades (incl. those that may already have been shared) = ', nrow(unshared))}
  }

  if(nrow(unshared) == 0){
    if(verbose){base::message('No grades to share. Stopping here.')}
  }else{

    # Filter to assignments
    if(!is.null(assignment_id)){
      assid <- assignment_id
      unshared <- unshared %>% dplyr::filter(assignment_id %in% assid)
      if(verbose){base::message('After filtering by assignment_id = ',nrow(unshared))}
    }

    # Filter by student
    if(!is.null(student_id)){
      unshared <- unshared %>% dplyr::filter(goes_by %in% student_id)
      if(verbose){base::message('After filtering by student_id = ',nrow(unshared))}
    }

    # Filter to only sharable ones
    if(nrow(unshared)>0){
      unshared <- unshared %>% dplyr::filter(share == TRUE)
      if(verbose){base::message('After filtering to grades specified for sharing = ',nrow(unshared))}
    }

    if(nrow(unshared)==0){
      if(verbose){base::message('No grades in need of sharing. Stopping here.')}
    }else{
      if(verbose){base::message('The following grades will be shared:\n')}
      print(unshared)
      proceed <- readline(prompt="Type y to proceed: ")
      #print(proceed)
      if(proceed=='y'){
        # Authorize gmailr
        gmailr::gm_auth_configure(path = json_path)

        # Loop through grades & send
        i=1
        for(i in 1:nrow(unshared)){
          (gradi <- unshared$grade_path[i])
          (report_fn <- gsub('grades','reports/grades', gsub('RData','pdf', gradi)))

          if(verbose){base::message(i, ' --- sharing ',gradi)}
          grade <- readRDS(gradi)

          if(grade$assignment$share){
            (studi <- grade$student$goes_by)
            (emaili <- grade$student$email)
            (coursi <- grade$assignment$course_id)
            (cati <- grade$assignment$assignment_category)
            (assi <- grade$assignment$assignment_id)
            (subject <- paste0(gsub('_',' ',coursi),' | Feedback on ', cati,': ',assi))
            (body <- paste0('Dear ', studi,',\n\nAttached you will find your grade on this assignment.\n\nPlease let me know if you have any questions or concerns.\n\nBest wishes,\nEKE'))

            # troubleshooting
            if(FALSE){
              base::message('student is ',studi)
              base::message('email is ',emaili)
              base::message('course is ',coursi)
              base::message('subject is ',subject)
              base::message('assignment is ',assi)
              base::message('email body is ',body)
            }

            # Compose message
            gmailr::gm_mime() %>%
              gmailr::gm_to(emaili) %>%
              gmailr::gm_from(your_email) %>%
              gmailr::gm_text_body(body) %>%
              gmailr::gm_subject(subject) %>%
              gmailr::gm_attach_file(file=report_fn) %>%
              gmailr::gm_send_message()

            Sys.sleep(1)

            if(verbose){base::message('  --- --- email sent to ', emaili, '\n')}

            # Change status to shared
            grade$shared <- TRUE
            # Re-save object
            saveRDS(grade, file=gradi)
          }else{
            #if(verbose){base::message('  --- --- this assignment was')}
          }
        }

        # deauthorize token
        gmailr::gm_deauth()
      }
    }
  }
}
