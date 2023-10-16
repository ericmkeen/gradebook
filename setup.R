# Create package

#library(devtools)
#create_package('/Users/erickeen/repos/gradebook')

# Super quick load (no install)
library(devtools) ; document()

# Import packages
if(FALSE){
  library(usethis)
  use_package('dplyr')
  use_package('readr')
  use_package('stringr')
  use_package('lubridate')
  use_package('usethis')
  use_package('devtools')
  use_package('shiny')
  use_package('shinyjs')
  use_package('shinydashboard')
  use_package('shinythemes')
  use_package('shinyWidgets')
  use_package('rintrojs')
  use_package('DataCombine')
  use_package('DT')
}

#use_mit_license()

# Send a test email to make sure gmailr is working =============================

json_path = '/Users/erickeen/repos/credentials/desktop_gradebook.json'
gmailr::gm_auth_configure(path=json_path)
gmailr::gm_auth()
gmailr::gm_mime() %>%
  gmailr::gm_to('ekezell@sewanee.edu') %>%
  gmailr::gm_from("ekezell@sewanee.edu") %>%
  gmailr::gm_text_body('gmailr test!') %>%
  gmailr::gm_subject('gmailr test!') %>%
  gmailr::gm_send_message()
# Instructions for setting up gmailR = https://gmailr.r-lib.org/dev/articles/oauth-client.html
# Other help = https://developers.google.com/identity/protocols/oauth2


# Install gradebook   ==========================================================
library(devtools)
devtools::install_github('ericmkeen/gradebook')
library(gradebook)

# Built-in datasets  ===========================================================

# Grace scale 1
grade_scale1 <- data.frame(letter = c('F', 'D', 'C', 'B', 'A'),
                           percent = c(55,  65,  75,   85,  95),
                           rubric_slot = 1:5,
                           description = c('Critical issues',
                                           'Many issues',
                                           'Focus on improving',
                                           'Strong / good',
                                           'Superb'))
grade_scale1
#usethis::use_data(grade_scale1, overwrite = TRUE)

# Grade scale 2
grade_scale2 <- data.frame(letter = c('F', 'C','A'),
                           percent = c(55,  75, 95),
                           rubric_slot = c(1,3,5),
                           description = c('Unacceptable', 'Incomplete', 'Complete'))
grade_scale2
#usethis::use_data(grade_scale2, overwrite = TRUE)

# Grade scale 3
grade_scale3 <- data.frame(letter = c('F', 'C','A'),
                           percent = c(55,  75, 95),
                           rubric_slot = c(1,3,5),
                           description = c('Critical issues', 'Several issues', 'No issue'))
grade_scale3
#usethis::use_data(grade_scale3, overwrite = TRUE)

# Default rubric
default_rubric <- list('Quality of content & ideas' = grade_scale1,
               'Writing' = grade_scale1,
               'Adherence to instructions' = grade_scale3,
               'Submitted without any hassle to instructor' = grade_scale3)
default_rubric
#usethis::use_data(default_rubric, overwrite = TRUE)

# Letter grade key
letter_grade_key <- data.frame(letter_basic  = c('A',  'A', 'A',  'B',  'B', 'B',  'C',  'C', 'C',  'D',  'D', 'D',  'F'),
                               letter_detail = c('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F'),
                               grade_floor   = c( 97,   93,  90,   87,   83,  80,   77,   73,  70,   67,   63,  60,  -Inf))
library(dplyr)
(letter_grade_key <-
  letter_grade_key %>%
  mutate(letter_detail = stringr::str_pad(letter_detail, width=2, side='right', pad=' ')))

usethis::use_data(letter_grade_key, overwrite = TRUE)


################################################################################
################################################################################
# Workflow example

# Setup course
setup_course('ESCI_220')
#setup_course('ENST_209')
#setup_course('ENST_101')

# Load student roster - DO NOT RERUN
#students_url <- 'https://docs.google.com/spreadsheets/d/1otjd7iItkm9wvexXxQNQxppvOmMEagc4NchcQilzsY4/edit?usp=sharing'
#update_roster('ESCI_220', students_url) # rerun this each time your googlesheet is changed

# Quick view student roster
view_students('ESCI_220')


# Create an assignment =========================================================

# Get submission portal
portal <- 'https://drive.google.com/drive/folders/1S2Jhtk5xgW_bZonKcQZ7UX-nvxcWvwNtu9ZQ1oUGlKtxS_9rVW5UOydeTINMTozRx6kviV_a?usp=sharing'

# Setup rubric
data(grade_scale1)
data(grade_scale2)
data(grade_scale3)
rubric <- list('Content' = 'category',
               '<b>All questions</b> attempted in full' = grade_scale2,
               'All code is correct & <u>error-free</u>' = grade_scale3,
               'Style' = 'category',
               'Data visualizations are <em>gorgeous</em>' = grade_scale1)
rubric

# Create an assignment
assignment(course_id = 'ESCI_220',
           assignment_id = '#1 Carbon emissions',
           assignment_category = 'R workshop',
           out_of = 10,
           due_date = 20230215,
           extra_credit = FALSE,
           share = TRUE,
           rubric = rubric,
           portal = portal,
           overwrite = TRUE)

# View all assignments & their status
view_assignments('ESCI_220')


# Grading workflow =============================================================

# Grade
grade()

# QA/QC
view_status('ESCI_220') # get a master list of all assignments on file and the grades that are already complete.
view_missing('ESCI_220') # are any students without a grade for an assignment that was already due?
report_grades('ESCI_220') # Re-render grade reports in a batch, if needed (helpful it modifying the ggplot code)

# Share grades
view_unshared('ESCI_220') # Return which grades have not yet been shared
email_grades(course_id = 'ESCI_220',
             unshared_only = TRUE,
             your_email = 'ekezell@sewanee.edu',
             json_path = '/Users/erickeen/repos/credentials/desktop_gradebook.json')



# STILL TO DO  =================================================================

# report_student() # basic bones
# report_class() # basic bones
# email_report() # basic bones
# general documentation
# vignette showing how to setup a course (use ESCI 209 as an example)


# Would be nice someday ========================================================

# disable grading button if a sutudent isnt selected





