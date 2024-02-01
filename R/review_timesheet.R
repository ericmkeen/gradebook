#' Review student timesheets that are submitted by Google Forms.
#'
#' @param course_id Course ID.
#' @param form_url The URL to the `GoogleSheet` containing `GoogleForm` responses.
#' Make sure link sharing is turned On. Student emails need to be collected with each submission.
#' @param form_cols A vector of new (simple) names to give the GoogleSheet columns. They can occur in any order needed to match your GoogleSheet, but
#' all the names listed in the default have to be assigned to a column in your form.
#' The column `hours` refers to the duration of a work session (must be a numerical value).
#' the column `percent` refers to the student's best estimate of what percent of the work session was spent on productive, focused work.
#' @param week_of_class_start Indicate which week of the year the class started in,
#' in order for the function to assign each timestamp submission to a week of the cours.
#'
#' @return A `data.frame` in which each row is hours worked in a week by a student.
#' @import dplyr
#' @import tidyr
#' @export
#'
review_timesheet <- function(roster,
                               form_url,
                               form_cols = c('email', 'date', 'hours', 'percent'),
                               week_of_class_start = 2){

  # ============================================================================
  message('\nDownloading in data from Google Form...')

  hourlog <- gsheet::gsheet2tbl(form_url) %>% select(2:5)
  names(hourlog) <- form_cols

  # ============================================================================
  message('Calculating cumulative and average weekly work totals...')

  suppressMessages({
    hourlog <-
    hourlog %>%
    mutate(hours = as.numeric(hours),
           percent = as.numeric(percent),
           adjusted = hours*(percent/100)) %>%
    mutate(date = lubridate::mdy(date),
           week_of_year = lubridate::week(date),
           week_of_class = week_of_year - week_of_class_start) %>%
    left_join(roster, by='email')
  })

  hourlog %>% head

  weeklog <-
    hourlog %>%
    group_by(goes_by) %>%
    arrange(date) %>%
    mutate(running_total = cumsum(adjusted)) %>%
    ungroup() %>%
    group_by(goes_by, week_of_class) %>%
    summarize(week_total = round(sum(adjusted), 2),
              week_running_total = round(sum(running_total), 2)) %>%
    mutate(weeks_to_date = week_of_class - 1) %>%
    mutate(weekly_avg = week_running_total / weeks_to_date) %>%
    arrange(goes_by, week_of_class)

  weeklog %>% head

  return(weeklog)

}
