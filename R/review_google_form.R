#' Review reading assignments submitted via Google Form, by printing submissions to the Console
#'
#' @param roster The course roster of students, to be formatted the same as result of `view_students()`.
#' @param form_url The URL to the `GoogleSheet` containing `GoogleForm` responses.
#' Make sure link sharing is turned On. Student emails need to be collected with each submission.
#' @param form_cols A vector of new (simple) names to give the GoogleSheet columns. They can occur in any order needed to match your GoogleSheet, but
#' all the names listed in the default have to be assigned to a column in your form.
#' The column `topic` is used to sort submissions by submission topic/theme.
#' The column `which` is used to sort submissions within a topic/theme into groups before printing.
#' Currently two groups are recognized by the function: `"Abstract"` and `"Discussion Q&A"`.
#' If the `which` column contains the value `"Abstract"`, the function will look for a reading summary in a column named `abstract`.
#' If the `which` column contains the value `"Discussion Q&A"`, the function will look for a discussion question in a column named `question`,
#' and it will look for a response in a column named `abstract`.
#' The column `graded` is used to indicate which entries you have already graded. You manually maintain this column within the `GoogleSheet`.
#' Each graded entry should have a `1` in this column. Ungraded entries should be blank.
#' @param week_of_class_start Indicate which week of the year the class started in,
#' in order for the function to assign each timestamp submission to a week of the cours.
#'
#' @return Submitted reading assignments are printed to the Console, sorted by week and assignment type. At the end of the loop, summary tables are returned as output.
#' @import dplyr
#' @import tidyr
#' @export
#'
review_google_form <- function(roster,
                               form_url,
                               form_cols = c('datetime', 'email', 'topic', 'which', 'question', 'abstract', 'graded'),
                               week_of_class_start = 2){

  # ============================================================================
  message('\nDownloading in data from Google Form...')

  roster <- view_students(course_id)
  (submissions <- gsheet::gsheet2tbl(form_url))
  submissions %>% names

  # ============================================================================
  message('Formatting data...')

  submissions <- submissions %>% select(1:length(form_cols))
  names(submissions) <- form_cols
  names(submissions)

  # Filter to ungraded
  submissions <- submissions %>% filter(graded != 1)

  # Join student info
  suppressMessages({
    submissions <- left_join(submissions, roster %>% select(email, goes_by))
  })
  submissions %>% names
  submissions <-
    submissions %>%
    rowwise() %>%
    mutate(words = length(stringr::str_split(abstract, ' ', simplify = TRUE))) %>%
    ungroup() %>%
    mutate(week_of_year = lubridate::week(lubridate::mdy_hms(datetime))) %>%
    mutate(week_of_course = week_of_year - week_of_class_start) %>%
    mutate(assignment_id = paste0('Week ', week_of_course,' ', topic))

  # ============================================================================
  # Select assignment

  (ass_ids <- submissions$assignment_id %>% unique)
  message('')
  message('===============================================')
  message('Found submissions for ', length(ass_ids), ' assignments: ')
  for(i in 1:length(ass_ids)){
    message(' --- ', i,'. ', ass_ids[i])
  }
  message(' --- ', i+1,'. Skip to submission summaries')

  message('===============================================')
  message('')
  ass_pick <- readline(prompt = 'Type number you want to grade = ')
  message('')
  (ass_pick <- as.numeric(ass_pick))

  if(ass_pick != i + 1){
    (assubs <-
       submissions %>%
       filter(assignment_id == ass_ids[ass_pick]))

    seper <- '  |  '
    if(nrow(assubs) == 0){
      message('No submissions found for this assignment! Quitting here!')
      stop()
    }else{
      message('There are ', nrow(assubs), ' submissions to grade.')
      message('')

      (discussions <- assubs %>% filter(which == "Discussion Q&A"))
      message('===============================================')
      message('DISCUSSION QUESTIONS  (n=',nrow(discussions),')')
      message('===============================================')

      if(nrow(discussions)>0){
        (discussions <- discussions %>% arrange(goes_by))
        for(i in 1:nrow(discussions)){
          (disci <- discussions[i, ])
          message('\n', disci$goes_by, seper, 'words = ',disci$words, seper, disci$datetime)
          message('')
          message('Question:')
          message(stringr::str_wrap(disci$question, width = 100))
          message('')
          message('Response:')
          abstracti <- disci$abstract
          (splits <- stringr::str_split(abstracti, '\n')[[1]])
          (splits <- splits[splits != ''])
          for(j in 1:length(splits)){
            message(stringr::str_wrap(splits[j], width = 100),'\n')
          }
          message('')
          if(i != nrow(discussions)){
            readline(prompt="Press [enter] to see next submission")
          }
        }
      }

      readline(prompt="\nNo more discussions to grade!\nPress [enter] to proceed to grading Abstracts")

      (discussions <- assubs %>% filter(which == "Abstract"))
      message('')
      message('===============================================')
      message('ABSTRACTS  (n=',nrow(discussions),')')
      message('===============================================')

      if(nrow(discussions)>0){
        (discussions <- discussions %>% arrange(goes_by))
        for(i in 1:nrow(discussions)){
          (disci <- discussions[i, ])
          message('\n', disci$goes_by, seper, 'words = ',disci$words, seper, disci$datetime)
          message('')
          abstracti <- disci$abstract
          (splits <- stringr::str_split(abstracti, '\n')[[1]])
          (splits <- splits[splits != ''])
          for(j in 1:length(splits)){
            message(stringr::str_wrap(splits[j], width = 100),'\n')
          }
          message('')
          if(i != nrow(discussions)){
            readline(prompt="Press [enter] to see next submission")
          }
        }
      }
    }

  }

  suppressMessages({
    sub_summary <-
      submissions %>%
      group_by(week_of_course, topic) %>%
      summarize(Total = n(),
                Abstracts = length(which(which == 'Abstract'))) %>%
      mutate(Discussion = Total - Abstracts)
  })

  suppressMessages({
    stud_summary <-
      submissions %>%
      group_by(goes_by) %>%
      summarize(Abstracts = length(which(which == 'Abstract')),
                Discussions = length(which(which == 'Discussion Q&A')))
  })

  return(list(submissions = sub_summary,
              students = stud_summary))


}
