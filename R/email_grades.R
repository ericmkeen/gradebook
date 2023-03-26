email_grades  <- function(course_id = NULL,
                          assignment_id = NULL,
                          student_id = NULL,
                          resend = FALSE,
                          json_path = FALSE,
                          verbose=TRUE){

  if(FALSE){ #=============================
    course_id <- NULL
    verbose=TRUE
    json_path = '/Users/erickeen/repos/credentials/gradebook.json'

    email_grades(json_path = json_path)
  } #======================================

  (unshared <- email_status(course_id = course_id, verbose=FALSE))
  if(verbose){base::message('Total unshared grades = ',length(unshared))}

  # Filter to assignments
  if(!is.null(assignment_id)){
    (splits <- strsplit(unshared, '---'))
    (asses <- lapply(splits,'[[', 2) %>% unlist)
    keeps <- which(asses %in% assignment_id)
    if(length(keeps)>0){
      unshared <- unshared[keeps]
    }
    if(verbose){base::message('After filtering by assignment_id = ',length(unshared))}
  }

  # Filter by student
  if(!is.null(student_id)){
    (splits <- strsplit(unshared, '---'))
    (studs <- lapply(splits,'[[', 3) %>% unlist)
    (studs <- gsub('.RData','',studs))
    keeps <- which(studs %in% student_id)
    if(length(keeps)>0){
      unshared <- unshared[keeps]
    }
    if(verbose){base::message('After filtering by student_id = ',length(unshared))}
  }

  # Filter to only sharable ones
  if(length(unshared)>0){
    i=1
    keeps <- c()
    for(i in 1:length(unshared)){
      (gradi <- unshared[i])
      (grade <- readRDS(gradi))
      if(grade$assignment$share){
        keeps <- c(keeps, i)
      }
    }
    if(length(keeps)>0){
      unshared <- unshared[keeps]
    }
    if(verbose){base::message('After filtering to grades to share = ',length(unshared))}
  }


  if(length(unshared)==0){
    if(verbose){base::message('No grades in need of sharing.')}
  }else{
    if(verbose){base::message('The following grades will be shared:\n')}
    print(unshared)
    proceed <- readline(prompt="Type y to proceed: ")
    print(proceed)
    if(proceed=='y'){
      # Authorize gmailr
      gmailr::gm_auth_configure(path = json_path)

      # Loop through grades & send
      i=1
      for(i in 1:length(unshared)){
        (gradi <- unshared[i])
        if(verbose){base::message(i, ' --- sharing ',gradi)}
        (grade <- readRDS(gradi))

        if(grade$assignment$share){
          (studi <- grade$student$goes_by)
          (emaili <- grade$student$email)
          (coursi <- grade$assignment$course_id)
          (cati <- grade$assignment$assignment_category)
          (assi <- grade$assignment$assignment_id)
          (subject <- paste0(gsub('_',' ',coursi),' | Feedback on ', cati,': ',assi))
          (body <- paste0('Dear ', studi,',\n\nAttached you will find your grade on this assignment.\n\nPlease let me know if you have any questions or concerns.\n\nBest wishes,\nEKE'))

        # Compose message
        gmailr::gm_mime() %>%
          gmailr::gm_to(emaili) %>%
          gmailr::gm_from("emkeen@sewanee.edu") %>%
          gmailr::gm_text_body(body) %>%
          gmailr::gm_subject(subject) %>%
          gmailr::gm_attach_file(file=gradi) %>%
          gmailr::gm_send_message()

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
