#' Email semester reports to students
#'
#' @param course_id Course ID.
#' @param student_id Optionally specify a student; otherwise unsent grades for all students will be sent.
#' @param report_date The date of the report to share, provided as a character string (format yyyy-mm-dd). Default is the current date according to your system's time.
#' @param your_email Your email address.
#' @param email_body The main body of the email message; this will appear one line below the greeting to the student.
#' @param json_path File path to your `json` credentials on your machine. This is necessary to send emails via the package `gmailr`.
#' @param verbose Print updates to console?
#'
#' @import dplyr
#'
#' @return desc
#' @export
#'
email_student_reports <- function(course_id,
                                  student_id = NULL,
                                  your_email,
                                  sign_off = 'Best wishes,\nYour professor.',
                                  report_date = lubridate::ymd(lubridate::date(Sys.time())),
                                  email_body = 'Attached you will find a report indicating your overall grade in the course to date. Please review this and reply to me with any questions or concerns.',
                                  json_path = FALSE,
                                  verbose=TRUE){

  if(FALSE){ #=============================
    course_id <- 'ENST_209'
    student_id <- 'Cole'
    student_id <- NULL
    verbose=TRUE
    (report_date = lubridate::ymd(lubridate::date(Sys.time())))
    your_email = 'ekezell@sewanee.edu'
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
      if(verbose){base::message('The following reports will be shared:\n')}
      print(reports)
      proceed <- readline(prompt="Type y to proceed: ")
      #print(proceed)
      if(proceed=='y'){
        # Authorize gmailr
        gmailr::gm_auth_configure(path = json_path)

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

          (subject <- paste0(gsub('_',' ',course_id),' | Semester progress report'))
          (body <- paste0('Dear ', studi,',\n\n',email_body))

            # troubleshooting
            if(FALSE){
              base::message('student is ',studi)
              base::message('email is ',emaili)
              base::message('course is ',course_id)
              base::message('subject is ',subject)
              base::message('email body is; \n\n',body)
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

            if(verbose){base::message('  --- --- email sent!\n')}
          } # end of email check
        } # end of loop
        message('\nFinished!')
      } # end of proceed check
    } # end of report student check #2
  } # end of report date check #1
}
