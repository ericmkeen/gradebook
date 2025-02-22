#' Send grades to students over email
#'
#' @param course_id Course ID.
#' @param assignment_id Optionally specify an assignment; otherwise unsent grades from all assignments will be sent.
#' @param student_id Optionally specify a student; otherwise unsent grades for all students will be sent.
#' @param your_email Your email address.
#' @param intro The introductory text used to address the student. Any instance of all-upper-case `"STUDENT"`
#' will be replaced with the student's `goes_by` name.
#' @param signoff How you wish to sign-off the email. The default is a generic "Best wishes, Your Professor."
#' @param email_body The main body of the email message; this will appear one line below the greeting to the student.
#' @param exempt_body The body to use in the event that a student is exempt fro mthe given assignment.
#' @param mode This function can operate in one of three modes:
#' (1) **`"test"`** (the default) will simulate sending emails without doing so, instead
#' printing the messages and attachments to the console for your review.
#' (Note that in `test` mode, you do not need to provide a `json` file, and the
#' grade's "shared" status will not change.).
#' (2) **`"draft"`** will prepare draft messages instead of sent emails, allowing you to go into
#' `Gmail` and review or modify the draft messages before sending.
#' (Note that in `draft` mode, each grade will be marked as "shared"!)
#' (3) **`"send"`** will actually send the emails.
#' As you start out in `gradebook`, we recommend beginning with `test`,
#' then graduating to `draft` and going to `Gmail` to actually commit to sending the drafted emails.
#' @param unshared_only Only share grades that have not yet been emailed? Default is `TRUE`.
#' @param json_path File path to your `json` credentials on your machine. This is necessary to send emails via the package `gmailr`.
#' @param verbose Print updates to console?
#'
#' @return Depends on `mode` input (see above).
#' @export
#'
email_grades  <- function(course_id,
                          assignment_id = NULL,
                          student_id = NULL,
                          your_email = 'ekezell@sewanee.edu',
                          intro = 'Dear STUDENT,',
                          signoff = 'Best wishes,\nYour professor',
                          email_body = 'Attached you will find your grade on this assignment.\n\nPlease let me know if you have any questions or concerns.',
                          exempt_body = 'This email is a confirmation that you were exempt from this assignment. Please let me know if you have any questions.',
                          mode = 'test',
                          unshared_only = TRUE,
                          json_path = NULL,
                          verbose=TRUE){

  if(FALSE){ #=============================
    mode <- 'send'
    mode <- 'draft'
    mode <- 'test'
    course_id <- 'ENST_421'
    assignment_id <- 'Week 04 journal'
    assignment_id <- NULL
    student_id <- NULL
    unshared_only <- FALSE
    unshared_only <- TRUE
    verbose=TRUE
    your_email = 'ekezell@sewanee.edu'
    json_path = '/Users/ekezell/repos/credentials/desktop_gradebook.json'
    intro = 'Dear STUDENT,'
    signoff = 'Best wishes,\nYour professor'
    email_body = 'Attached you will find your grade on this assignment.\n\nPlease let me know if you have any questions or concerns.'
    exempt_body = 'This email is a confirmation that you were exempt from this assignment. Please let me know if you have any questions.'
    #email_grades(json_path = json_path)

  } #======================================

  # Get unshared grades
  #(unshared <- view_unshared(course_id = course_id, mode = 'complete', verbose=FALSE))
  #if(is.null(unshared)){unshared <- data.frame()}
  #unshared

  unshared <- data.frame()
  if(unshared_only){
    (unshared <- view_unshared(course_id = course_id, mode = 'complete', verbose=FALSE))
    if(verbose){base::message('Total unshared grades = ',nrow(unshared))}
  }else{
    (unshared <- view_status(course_id = course_id) %>% filter(graded == TRUE))
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
      if(verbose){
        if(mode == 'send'){base::message('The following grades will be sent to students:\n')}
        if(mode == 'draft'){base::message('The following grades will be staged in draft emails to students (not actually sent):\n')}
        if(mode == 'test'){base::message('The following grades will be FAKE sent (TEST VERSION ONLY -- no emails will be sent):\n')}
      }
      print(unshared)
      proceed <- readline(prompt="Type y to proceed: ")
      message('')
      #print(proceed)
      if(proceed=='y'){

        if(mode %in% c('draft', 'send')){
          # Authorize gmailr
          gmailr::gm_auth_configure(path = json_path)
        }

        # Loop through grades & send
        i=1
        for(i in 1:nrow(unshared)){
          (gradi <- unshared$grade_path[i])
          (report_fn <- gsub('grades','reports/grades', gsub('RData','pdf', gradi)))

          if(verbose){base::message(i, ' --- sharing ',gradi)}
          grade <- readRDS(gradi)

          if(grade$assignment$share){
            (exempt_check <- grade$exemption)
            (studi <- grade$student$goes_by)
            (emaili <- grade$student$email)
            (coursi <- grade$assignment$course_id)
            (cati <- grade$assignment$assignment_category)
            (assi <- grade$assignment$assignment_id)
            (opener <- gsub('STUDENT', studi, intro))

            if(exempt_check){
              (subject <- paste0(gsub('_',' ',coursi),' | Exemption for ', cati,': ',assi))
              (body <- paste0(opener,'\n\n',exempt_body,'\n\n',signoff))
            }else{
              (subject <- paste0(gsub('_',' ',coursi),' | Feedback on ', cati,': ',assi))
              (body <- paste0(opener,'\n\n',email_body,'\n\n',signoff))
            }

            # TEST SEND ========================================================
            # no actual sending, just print content to Console
            if(mode == 'test'){
              base::message('\nStudent name (based on grade file): ',studi)
              base::message('Student email (based on grade file): ',emaili)

              base::message('\n=================================================================')
              base::message('SUBJECT:  ',subject)
              base::message('\n',body)
              base::message('=================================================================')

              if(exempt_check){
                base::message('\nNO ATTACHMENT (Student is exempt from assignment)')
              }else{
                base::message('\nATTACHMENT FILE:  ',report_fn)
              }
              base::message('\n')
              # Wait for user
              if(i < nrow(unshared)){ readline(prompt="Press [enter] to continue") }
              base::message('\n')
            } # end of mode = test

            # JUST DRAFT  ======================================================
            if(mode == 'draft'){
              if(exempt_check){
                gmailr::gm_mime() %>%
                  gmailr::gm_to(emaili) %>%
                  gmailr::gm_from(your_email) %>%
                  gmailr::gm_text_body(body) %>%
                  gmailr::gm_subject(subject) %>%
                  gmailr::gm_create_draft()
              }else{
                gmailr::gm_mime() %>%
                  gmailr::gm_to(emaili) %>%
                  gmailr::gm_from(your_email) %>%
                  gmailr::gm_text_body(body) %>%
                  gmailr::gm_subject(subject) %>%
                  gmailr::gm_attach_file(file=report_fn) %>%
                  gmailr::gm_create_draft()
              }
              Sys.sleep(2)
              if(verbose){base::message('  --- --- email draft staged for ', emaili, '\n')}
              # Change status to shared & resave
              grade$shared <- TRUE
              saveRDS(grade, file=gradi)
            } # end of mode == 'draft'

            # ACTUALLY SEND  ===================================================
            if(mode == 'send'){
              # Prep and send email
              if(exempt_check){
                gmailr::gm_mime() %>%
                  gmailr::gm_to(emaili) %>%
                  gmailr::gm_from(your_email) %>%
                  gmailr::gm_text_body(body) %>%
                  gmailr::gm_subject(subject) %>%
                  gmailr::gm_send_message()
              }else{
                gmailr::gm_mime() %>%
                  gmailr::gm_to(emaili) %>%
                  gmailr::gm_from(your_email) %>%
                  gmailr::gm_text_body(body) %>%
                  gmailr::gm_subject(subject) %>%
                  gmailr::gm_attach_file(file=report_fn) %>%
                  gmailr::gm_send_message()
              }

              Sys.sleep(2)
              if(verbose){base::message('  --- --- email sent to ', emaili, '\n')}
              # Change status to shared & resave
              grade$shared <- TRUE
              saveRDS(grade, file=gradi)
            } # end of mode == 'send'

          }else{
            # this assignment is not supposed to be sshared
          }
        } # loop through each grade to share

        if(mode %in% c('draft','send')){
          # deauthorize token
          gmailr::gm_deauth()
        }
      } # end of proceed y if
    } # end of if there are any unshared grades to share (after filtering by assignment/student)
  } # end of if there are any unshared grades to share
}
