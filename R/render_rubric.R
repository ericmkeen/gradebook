#' Render rubric
#'
#' @param course_id Course ID
#' @param assignment_id Assignment ID name
#'
#' @return Saves a PDF into the course's rubrics folder.
#' @export
#' @import dplyr
#' @import ggplot2
#'
render_rubric <- function(course_id,
                          assignment_id){

  if(FALSE){
    course_id <- 'ESCI_220'
    assignment_id <- '#1 Carbon emissions'
    rubric_render(course_id, assignment_id)

    course_id <- 'ENST_209'
    assignment_id <- 'Question 1 (pre-submitted)'

    course_id <- 'ENST_101'
    assingment_id
  }

  (assdir <- paste0(course_id,'/assignments/'))
  (asslf <- dir(assdir))
  (assi <- asslf[which(grepl(assignment_id, asslf))])
  (assfull <- paste0(assdir, assi))
  (ass <- readRDS(assfull[1]))
  (rubric <- ass$rubric)

  # Only proceed if rubric is not NULL:
  if(!is.null(rubric)){

    # Expand rubric ==============================================================

    rubric

    rubric_expanded <- data.frame()
    i=2
    for(i in 1:length(rubric)){
      (standard <- rubric[i] %>% names)
      (rubi <- rubric[[i]])
      if(is.data.frame(rubi)){
        rubric_slot <- rubi$rubric_slot
        rubric_percent <- rubi$percent
        rubric_letter <- rubi$letter
        rubric_description <- rubi$description
      }else{
        rubric_slot <- NA
        rubric_percent <- NA
        rubric_letter <- NA
        rubric_description <- NA
      }
      rubrici <- data.frame(standard,
                            percent = rubric_percent,
                            letter = rubric_letter,
                            description = rubric_description,
                            rank=i)
      rubric_expanded <- rbind(rubric_expanded, rubrici)
    }
    rubric_expanded

    # Convert formatting from HTML to RMD ========================================
    standard_rmd <- rubric_expanded$standard
    standard_rmd
    standard_rmd <- gsub('<b>','**', standard_rmd)
    standard_rmd <- gsub('</b>','**', standard_rmd)
    standard_rmd <- gsub('<em>','*', standard_rmd)
    standard_rmd <- gsub('</em>','*', standard_rmd)
    standard_rmd <- gsub('<u>','**', standard_rmd)
    standard_rmd <- gsub('</u>','**', standard_rmd)
    for(i in 1:nrow(rubric_expanded)){
      if(is.na(rubric_expanded$percent[i])){
        standard_rmd[i] <- paste0('**',standard_rmd[i],'**')
      }
    }
    standard_rmd

    # Wrap standard text
    i=2
    for(i in 1:length(standard_rmd)){
      (si <- standard_rmd[i])
      standard_rmd[i] <- paste(strwrap(si, 35), collapse='<br>')
    }
    standard_rmd
    rubric_expanded$standard_rmd <- standard_rmd

    # Wrap description text
    i=11
    for(i in 1:nrow(rubric_expanded)){
      (si <- rubric_expanded$description[i])
      rubric_expanded$description[i] <- paste(strwrap(si, 9), collapse='\n')
    }
    rubric_expanded$description

    # Build plot  ================================================================

    rubric_expanded$standard_rmd
    rubric_expanded$percent <- as.numeric(rubric_expanded$percent)
    rubric_expanded <- rubric_expanded %>% mutate(standard_rmd = forcats::fct_reorder(standard_rmd, rank))

    p <-
      ggplot(rubric_expanded) +
      geom_point(mapping=aes(y=standard_rmd,
                             x=percent)) +
      scale_y_discrete(limits=rev) +
      geom_hline(yintercept=rubric_expanded$standard_rmd[!is.na(rubric_expanded$percent)], alpha=.5) +
      geom_text(mapping=aes(y=standard_rmd,
                            x=percent,
                            label=description),
                vjust = 1.5,
                size = 8/.pt) +
      xlim(30, 100) +
      ylab(NULL) +
      xlab('Percentage') +
      theme(plot.title = element_markdown(size = 11, lineheight = 1.2),
            axis.text.y=ggtext::element_markdown(),
            plot.caption = ggtext::element_markdown())

    #p

    # Prepare titles and subtitles  ==============================================

    sepr = '  |  '
    titi <- paste0('**Rubric:** ', gsub('_', ' ', course_id), sepr, gsub('.rds','',gsub(' --- ', sepr, assi)))
    subtit <- paste0('Due ',ass$due_date, sepr, 'Worth ', ass$out_of, ' points')
    p <- p + labs(title = titi, subtitle= subtit)
    #p

    # Prep file name
    (rub_file <- paste0(course_id,'/rubrics/',gsub('rds','pdf',assi)))

    # Save it
    (lines <- (rubric %>% length)*.7)
    ggsave(filename=rub_file, width=7, height=max(c(5, lines)))

  }

}
