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


# Install gradebook
library(devtools)
devtools::install_github('ericmkeen/gradebook')
library(gradebook)


# Try it =======================================================================

# Setup course
setup_course('ENST_320')

# Load student roster
students_url <- 'https://docs.google.com/spreadsheets/d/1otjd7iItkm9wvexXxQNQxppvOmMEagc4NchcQilzsY4/edit?usp=sharing'
update_roster('ENST_320', students_url)











