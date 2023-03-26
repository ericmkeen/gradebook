#' Create an assignment
#'
#' @param course_id desc
#' @param assignment_id desc
#' @param assignment_category desc
#' @param out_of desc
#' @param due_date desc
#' @param extra_credit desc
#' @param share desc
#' @param rubric desc
#' @param portal desc
#' @param overwrite desc
#'
#' @return
#' @export
#'
assignment <- function(course_id,
                       assignment_id,
                       assignment_category,
                       out_of,
                       due_date,
                       extra_credit = FALSE,
                       share = TRUE,
                       rubric = NULL,
                       portal = NULL,
                       overwrite = TRUE){

  if(FALSE){ #==================================================================

    course_id <- 'ENST_320'
    assignment_id <- '#1 Carbon emissions'
    assignment_category <- 'R workshop'
    out_of <- 10
    due_date <- '02-03-2023'
    extra_credit = FALSE
    share=TRUE
    overwrite <- TRUE
    portal <- 'https://drive.google.com/drive/folders/1S2Jhtk5xgW_bZonKcQZ7UX-nvxcWvwNtu9ZQ1oUGlKtxS_9rVW5UOydeTINMTozRx6kviV_a?usp=sharing'

    grade_scale1 <- data.frame(letter = c('F', 'D', 'C', 'B', 'A'),
                               percent = c(55,  65,  75,   85,  95),
                               description = c('Critical issues',
                                               'Many issues',
                                               'Focus on improving',
                                               'Strong/good',
                                               'Superb'))
    grade_scale1

    rubric <- list('All questions attempted in full' = grade_scale1[1:4,],
                   'All code is correct & error-free' = grade_scale1[1:4,],
                   'Data visualizations' = grade_scale1)
    rubric

    # Try it
    assignment(course_id, assignment_id, assignment_category,
               out_of, due_date, extra_credit, share, rubric, portal,
               overwrite)

  } #===========================================================================

  # Compile list for assignment
  ass_list <- list(course_id = course_id,
                   assignment_id = assignment_id,
                   assignment_category = assignment_category,
                   out_of = out_of,
                   due_date = lubridate::mdy(due_date),
                   extra_credit = extra_credit,
                   overwrite = overwrite,
                   share = share,
                   portal = portal,
                   rubric = rubric)

  ass_list

  # Prepare filename
  (ass_fn <- paste0(course_id, '/assignments/', assignment_category, ' --- ', assignment_id, '.rds'))

  # Save to assignments folder
  if(dir.exists(ass_fn)){
    if(overwrite){
      saveRDS(ass_list, file=ass_fn)
    }
  }else{
    saveRDS(ass_list, file=ass_fn)
  }

}
