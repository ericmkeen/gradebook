#' Plot assignment weights
#'
#' @param course_id Course ID
#'
#' @return A `ggplot`
#' @export
#' @import dplyr
#' @import ggplot2
#'
plot_assignment_weights <- function(course_id){

  (ass <- view_assignments(course_id))

  (asstab <-
      ass %>%
      group_by(assignment_category) %>%
      summarize(points = sum(out_of)) %>%
      mutate(percent = 100*(points / sum(points))) %>%
      arrange(desc(percent)))

  ggplot(asstab,
         aes(x=percent,
             y=assignment_category)) +
    geom_col(fill='darkblue', alpha=.6) +
    xlab('Percent of final grade') +
    ylab(NULL) +
    labs(title=paste0(gsub('_',' ',course_id),' assignment weights'))

}
