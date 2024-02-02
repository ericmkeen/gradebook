#' Send a test email
#'
#' @param recipient Receipient email address, for testing.
#' @param your_email Your email address.
#' @param json_path File path to your `json` credentials on your machine. This is necessary to send emails via the package `gmailr`.
#' @param verbose Print updates to console?
#'
#' @return An email is sent, updates are written to Console.
#' @import dplyr
#' @export
#'
email_test  <- function(recipient,
                        your_email,
                        intro = 'Dear STUDENT,',
                        signoff = 'Best wishes,\nProf. Ezell',
                        email_body =  "This is a test email using the gradebook R package.",
                        json_path,
                        verbose = TRUE){

  if(FALSE){ #=============================
    recipient = 'ekezell@sewanee.edu'
    your_email = 'ekezell@sewanee.edu'
    json_path = '/Users/ekezell/repos/credentials/desktop_gradebook.json'
    verbose = TRUE
    #email_test(json_path = json_path)

  } #======================================

  # Authorize gmailr
  gmailr::gm_auth_configure(path = json_path)

  (studi <- 'STUDENT')
  (emaili <- recipient)
  (coursi <- 'TEST_COURSE')
  (cati <- 'ASSIGNMENT_CATEGORY')
  (assi <- 'ASSIGNMENT_ID')
  (subject <- paste0(gsub('_',' ',coursi),' | Feedback on ', cati,': ',assi))
  (body <- paste0(intro,'\n\n',email_body,'\n\n',signoff))

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
    gmailr::gm_send_message()

  Sys.sleep(1)

  if(verbose){base::message('  --- --- email sent to ', emaili, '\n')}

  # deauthorize token
  gmailr::gm_deauth()

}
