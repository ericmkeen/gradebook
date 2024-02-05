#' Email semester reports to students
#'
#' @param course_id Course ID.
#' @param student_id Optionally specify a student; otherwise unsent grades for all students will be sent.
#' @param report_date The date of the report to share, provided as a character string (format yyyy-mm-dd). Default is the current date according to your system's time.
#' @param your_email Your email address.
#' @param intro The introductory text used to address the student. Any instance of all-upper-case `"STUDENT"`
#' will be replaced with the student's `goes_by` name.
#' @param signoff How you wish to sign-off the email. The default is a generic "Best wishes, Your Professor."
#' @param email_body The main body of the email message; this will appear one line below the greeting to the student.
#' @param json_path File path to your `json` credentials on your machine. This is necessary to send emails via the package `gmailr`.
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
#' @param verbose Print updates to console?
#'
#' @import dplyr
#'
#' @return desc
#' @export
#'
email_student_reports <- function(course_id,
                                  your_email,
                                  student_id = NULL,
                                  report_date = lubridate::ymd(lubridate::date(Sys.time())),
                                  intro = 'Dear STUDENT,',
                                  signoff = 'Best wishes,\nYour professor',
                                  email_body = 'Attached you will find a report indicating your overall grade in the course to date. Please review this and reply to me with any questions or concerns.',
                                  mode = 'test',
                                  json_path = FALSE,
                                  verbose=TRUE){

  if(FALSE){ #=============================
    mode <- 'send'
    mode <- 'draft'
    mode <- 'test'
    course_id <- 'ENST_209'
    student_id <- 'Cole'
    student_id <- NULL
    verbose=TRUE
    (report_date = lubridate::ymd(lubridate::date(Sys.time())))
    your_email = 'ekezell@sewanee.edu'
    intro = 'Dear STUDENT,'
    signoff = 'Best wishes,\nYour professor'
    json_path = '/Users/ekezell/repos/credentials/desktop_gradebook.json'
    email_body = 'Attached you will find a report indicating your grade in the course to date, with a summary of each grade I have on file for you. Please review this and reply to me if you believe any of my records are erroneous. Note that any overdue assignment (ones currently with a zero) can be updated if you submit the make-up materials.\n\nPlease let me know if you have any questions or concerns.\n\nBest wishes!\n\nProf. Ezell'
    email_body
    #email_grades(json_path = json_path)

  } #======================================

  # get students
  (studs <- view_students(course_id))

  # get reports
  (subdir <- paste0(course_id,'/reports/students/'))
  (lf <- dir(subdir))
  (reports <- paste0(subdir, lf))

  # Filter to reports from a certain date
  (keeps <- grepl(report_date, reports))
  (reports <- reports[keeps])
  if(length(reports)==0){
    message('No reports on file for this date! Stopping here!')
    return()
  }else{

    # Filter by student
    if(!is.null(student_id)){
      (keeps <- grepl(student_id, reports))
      (reports <- reports[keeps])
    }

    if(length(reports)==0){
      message('No reports on file! Stopping here!')
      return()
    }else{

      # Proceed
      if(verbose){
        if(mode == 'send'){base::message('The following reports will be sent to students:\n')}
        if(mode == 'draft'){base::message('The following reports will be staged in draft emails to students (not actually sent):\n')}
        if(mode == 'test'){base::message('The following reports will be FAKE sent (TEST VERSION ONLY -- no emails will be sent):\n')}
      }
      print(reports)
      proceed <- readline(prompt="Type y to proceed: ")
      #print(proceed)
      if(proceed=='y'){

        if(mode %in% c('draft', 'send')){
          # Authorize gmailr
          gmailr::gm_auth_configure(path = json_path)
        }

        # Loop through reports & send
        i=1
        for(i in 1:length(reports)){
          (report_fn <- reports[i])
          (repi <- gsub('.pdf','',report_fn))
          (studi <- strsplit(repi,' --- ')[[1]])
          (ni <- length(studi))
          (studi <- studi[ni])

          # Match to emails
          (emaili <- studs %>% filter(goes_by == studi) %>% pull(email))

          if(length(emaili)!=1){
            message('Error! We did not get only 1 email address for student name ', studi,'. Stopping here!')
            return()
          }else{
            if(verbose){base::message(i, ' --- sharing report for ',studi, ' at ', emaili)}

            (subject <- paste0(gsub('_',' ',course_id),' | Progress report'))
            (opener <- gsub('STUDENT', studi, intro))
            (body <- paste0(opener,'\n\n',email_body,'\n\n',signoff))

            # TEST SEND ========================================================
            # no actual sending, just print content to Console
            if(mode == 'test'){
              base::message('\nStudent name (based on report file): ',studi)
              base::message('Student email (based on student roster): ',emaili)
              base::message('\n=================================================================')
              base::message('SUBJECT:  ',subject)
              base::message('\n',body)
              base::message('=================================================================')
              base::message('\nATTACHMENT FILE:  ',report_fn)
              base::message('\n')
              # Wait for user
              if(i < nrow(unshared)){ readline(prompt="Press [enter] to continue") }
              base::message('\n')
            } # end of mode = test

            # JUST DRAFT  ===================================================
            if(mode == 'draft'){
              # Compose message
              gmailr::gm_mime() %>%
                gmailr::gm_to(emaili) %>%
                gmailr::gm_from(your_email) %>%
                gmailr::gm_text_body(body) %>%
                gmailr::gm_subject(subject) %>%
                gmailr::gm_attach_file(file=report_fn) %>%
                gmailr::gm_create_draft()
              Sys.sleep(2)
              if(verbose){base::message('  --- --- email draft staged!\n')}
            }

            # ACTUALLY SEND  ===================================================
            if(mode == 'send'){
              # Compose message
              gmailr::gm_mime() %>%
                gmailr::gm_to(emaili) %>%
                gmailr::gm_from(your_email) %>%
                gmailr::gm_text_body(body) %>%
                gmailr::gm_subject(subject) %>%
                gmailr::gm_attach_file(file=report_fn) %>%
                gmailr::gm_send_message()
              Sys.sleep(2)
              if(verbose){base::message('  --- --- email sent!\n')}
            }

          } # end of email check
        } # end of loop
        message('\nFinished!')
        if(mode %in% c('draft','send')){
          # deauthorize token
          gmailr::gm_deauth()
        }
      } # end of proceed check
    } # end of report student check #2
  } # end of report date check #1
}
