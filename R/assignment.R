#' Create an assignment
#'
#' Create an assignment for a course, with rubric and all other details attached.
#'
#' @param course_id Course ID
#' @param assignment_id Unique identifier for assignment.
#' @param assignment_category Category of assignments this assignment belongs to (e.g., 'Reading quizzes', or 'Essays', or 'Exams').
#' @param out_of Number of points this assignment is worth.
#' @param due_date Due date of assignment, in the format `YYYY-MM-DD`.
#'
#' @param extra_credit If `TRUE`, this is an extra credit opportunity and should be treated as such in downstream grade calculations.
#'
#' @param share If `TRUE`, the grade for this assignment should be emailed to the students. It can be handy to set this to `FALSE` for regular completion grades, such as reading quizzes.
#'
#' @param rubric Provide an optional rubric here, in the form of a list in which each slot is named with a character string indicating what is being assessed (e.g., 'Quality of writing') and the content of each slot is a grade scale (see built-in dataset `grade_scale1` as an example). If left as `NULL`, the default rubric will be used (see the built-in dataset `default_rubric`).
#'
#' @param show_percentage Boolean; share the precise grade percentage, or just the letter grade?
#'
#' @param letter_key  Optional, and only used if `show_percentage` is `FALSE`; include a key for translating a percentage to a letter grade.
#' For required format, see `data(letter_grade_key)`; you can also type `"default"`, and the function
#' will load `data(letter_grade_key)` for you and use it.
#'
#' @param portal Option to include a URL (as a character string) to the portal where submissions can be found. For convenience only.
#'
#' @param overwrite If `TRUE`, running this function will overwrite any existing assignments with the same `assignment_id`. This is a useful way to update assignment details.
#'
#' @return This function will save this assignment into an `.rds` file within the `assignments` subfolder for the relevant course. It will also save a stylized version of the rubric to the `rubrics` folder.
#' @export

assignment <- function(course_id,
                       assignment_id,
                       assignment_category,
                       out_of,
                       due_date,
                       extra_credit = FALSE,
                       share = TRUE,
                       rubric = NULL,
                       show_percentage = TRUE,
                       letter_key = 'default',
                       portal = NULL,
                       overwrite = TRUE){

  if(FALSE){ #==================================================================
    course_id <- 'ENST_209'
    assignment_id <- 'Book podcast'
    assignment_category <- 'Book podcast'
    out_of <- 3
    due_date <- '2023-08-28'
    extra_credit <- FALSE
    share <- TRUE
    overwrite <- TRUE
    (response_rubric <- list('Submission seems complete and on-topic' = grade_scale2))
    portal <- NULL

    course_id <- 'ESCI_220'
    assignment_id <- '#1 Carbon emissions'
    assignment_category <- 'R workshop'
    out_of <- 10
    due_date <- '02-03-2023'
    extra_credit <- FALSE
    share <- TRUE
    overwrite <- TRUE
    portal <- 'https://drive.google.com/drive/folders/1S2Jhtk5xgW_bZonKcQZ7UX-nvxcWvwNtu9ZQ1oUGlKtxS_9rVW5UOydeTINMTozRx6kviV_a?usp=sharing'

    data(grade_scale1)
    data(grade_scale2)
    data(grade_scale3)

    rubric <- list('All questions attempted in full' = grade_scale2,
                   'All code is correct & error-free' = grade_scale3,
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
                   due_date = lubridate::ymd(due_date),
                   extra_credit = extra_credit,
                   overwrite = overwrite,
                   share = share,
                   show_percentage = show_percentage,
                   letter_key = letter_key,
                   portal = portal,
                   rubric = rubric)

  ass_list
  #print(ass_list)

  # Prepare filename
  (ass_fn <- paste0(course_id, '/assignments/', assignment_category, ' --- ', assignment_id, '.rds'))
  base::message(ass_fn)

  # Save to assignments folder
  if(dir.exists(ass_fn)){
    base::message(' --- This assignment already exists on file.')
    if(overwrite){
      base::message(' --- saving assignment (overwrite)...')
      saveRDS(ass_list, file=ass_fn)
      if(!is.null(rubric)){
        base::message(' --- rendering rubric (overwrite)...')
        render_rubric(course_id, assignment_id)
      }
    }
  }else{
    base::message(' --- This assignment is not yet on file.')
    base::message(' --- --- saving assignment...')
    saveRDS(ass_list, file=ass_fn)
    if(!is.null(rubric)){
      base::message(' --- --- rendering rubric...')
      render_rubric(course_id, assignment_id)
    }
  }

}
