#' Plot cumulative points throughout semester
#'
#' @param course_id
#'
#' @return A `ggplot`.
#' @export
#' @import ggplot2
#' @import dplyr
#'
plot_assignment_calendar <- function(course_id){

  (ass <- view_assignments(course_id))

  asscum <-
    ass %>%
    arrange(due_date) %>%
    mutate(cum_points = cumsum(out_of))

  ggplot() +
    geom_path(data=asscum,
              mapping=aes(x=due_date,
                          y=cum_points),
              size=1,
              alpha=.5) +
              #position=position_dodge(width=1)) +
    geom_point(data=asscum,
               mapping=aes(x=due_date,
                           y=cum_points,
                           color=assignment_category,
                           size=out_of),
               alpha=.85) +
    labs(size='Points possible',
         color='Category',
         x = 'Due date',
         y = 'Cumulative points possible',
         title = paste0(gsub('_', ' ', course_id), ' course calendar'),
         subtitle = 'showing points possible throughout semester')

}
