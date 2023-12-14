
#' Drop lowest grade (convert to exemption)
#'
#' @param grades The result of `view_status`, filtered to have only assessments of interest (e.g., already graded and already due).
#' @param assignment_categories Character vector of `assigment_category`'s in which you want to drop the lowest grade.
#'
#' @return Revised grades `data.frame`, where the lowest grade in each category is changed to `exemption == TRUE` (no rows are removed).
#' @export
#' @import dplyr
#' @import tidyr

drop_lowest_grade <- function(grades, assignment_categories){
  mrs <- grades
  mrs$i <- 1:nrow(mrs)

  suppressMessages({
    i_to_drop <-
      mrs %>%
      filter(assignment_category %in% assignment_categories) %>%
      group_by(goes_by, assignment_category) %>%
      mutate(lowest = min(percent, na.rm=TRUE)) %>%
      mutate(highest = max(percent, na.rm=TRUE)) %>%
      mutate(high_test = lowest == highest) %>%
      mutate(exempt_test = any(exemption)) %>%
      mutate(i_drop = tail(i[percent == lowest], 1)) %>%
      mutate(i_drop = ifelse(high_test | exempt_test, NA, i_drop)) %>%
      summarize(lowest = lowest[1],
                high_test = high_test[1],
                i_drop = tail(i_drop, 1)) %>%
      filter(!is.na(i_drop)) %>%
      pull(i_drop)
  })
  i_to_drop

  if(length(i_to_drop)>0){
    table(mrs$exemption)
    mrs$exemption[mrs$i %in% i_to_drop] <- TRUE
    table(mrs$exemption)
  }

  mrs <- mrs %>% select(-i)

}
