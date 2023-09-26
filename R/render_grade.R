#' Render the report for a grade
#'
#'
#' This function produces a .PNG (using `ggplot2`)
#'
#' @param grade_file Path to grade file (`.rds`).
#'
#' @return Render the report for a grade (in `<course>/reports/grades/`), save it to PNG, and update the `grade` file.
#'
#' @export
#' @import ggplot2
#' @import dplyr
#' @import ggtext
#' @import ggpubr
#'
render_grade <- function(grade_file){

  if(FALSE){ #========================
    grade_file <- "ENST_101/grades/ENST_101 --- News brief --- News brief 1 --- Ivy.RData"
    grade_file <- "ESCI_220/grades/ESCI_220 --- R workshop --- #1 Carbon emissions --- ekezell.RData"
    grade_file <- "ESCI_220/grades/ESCI_220 --- R workshop --- #1 Carbon emissions --- ericmkeen.RData"
    grade_file <- 'ENST_209/grades/ENST_209 --- Reading quiz --- Week 13 Wednesday quiz --- Student 2.RData'
    grade_file <- 'ENST_209/grades/ENST_209 --- Book podcast --- Book podcast --- Student 3.RData'
    grade_file <- 'ESCI_220/grades/ESCI_220 --- Mini-Watson --- Mini-Watson Pre-proposal --- Christian.RData'
    grade_file <- 'ESCI_220/grades/ESCI_220 --- Mini-Watson --- Mini-Watson full proposal --- Zach.RData'
    render_grade(grade_file)
  } #=================================

  # Read in grade
  grade <- readRDS(grade_file)

  # Convert formatting from HTML to RMD ========================================
  standard_rmd <- grade$rubric_grades$standard
  standard_rmd <- gsub('<b>','**', standard_rmd)
  standard_rmd <- gsub('</b>','**', standard_rmd)
  standard_rmd <- gsub('<em>','*', standard_rmd)
  standard_rmd <- gsub('</em>','*', standard_rmd)
  standard_rmd <- gsub('<u>','**', standard_rmd)
  standard_rmd <- gsub('</u>','**', standard_rmd)
  standard_rmd
  for(i in 1:nrow(grade$rubric_grades)){
    if(grade$rubric_grades$decision[i] == 'category'){
      standard_rmd[i] <- paste0('**',standard_rmd[i],'**')
    }
  }
  grade$rubric_grades$standard_rmd <- standard_rmd

  grade$rubric_grades$rank <- nrow(grade$rubric_grades):1 #%>% factor


  # Build plot  ================================================================

  wrapper <- function(x, ...) paste(strwrap(x, ...), collapse = "\n")
  grade$rubric_grades
  grade$rubric_grades$standard_rmd <-
    sapply(grade$rubric_grades$standard_rmd, function(x){paste(strwrap(x, 30), collapse='<br>')})

  grade$rubric_grades$percent <- as.numeric(grade$rubric_grades$percent)

  p <-
    ggplot(grade$rubric_grades) +
    geom_point(mapping=aes(y=rank,
                           x=percent)) +
    geom_segment(mapping=aes(y=rank,
                             yend=rank,
                             x=0,
                             xend=percent),
                 alpha=.6) +
    geom_text(mapping=aes(y=rank,
                          x=percent,
                          label=decision),
              size= 7/.pt,
              vjust = -1.5) +
    xlim(0, 100) +
    scale_y_continuous(labels=(grade$rubric_grades$standard_rmd),
                       breaks = grade$rubric_grades$rank) +
    #scale_y_continuous(labels=(rev(grade$rubric_grades$standard_rmd)),
    #                   breaks = grade$rubric_grades$rank) +
    ylab(NULL) +
    xlab('Percentage') +
    geom_vline(xintercept = grade$percent, lty=2, color='firebrick', lwd=.8, alpha=.6) +
    theme(axis.text.y= ggtext::element_markdown(),
          plot.caption = ggtext::element_markdown())

  #p

  # Prepare titles and subtitles  ==============================================

  assi <- paste0(gsub('_',' ',grade$course), '   |   ',
                 grade$assignment$assignment_category,'   |   ',
                 grade$assignment$assignment_id)

  studi <- paste0('Submitted by ', grade$student$goes_by, '  |  Due date: ',
                  grade$assignment$due_date)

  # Prepare caption
  (capti <- paste0('**Percentage**', ' = ', round(grade$percent,1), '<br>',
                   '**Points toward final grade**', ' = ', round(grade$points,1),' out of ', grade$assignment$out_of))
  if(grade$exemption == TRUE){
    capti <- paste0(capti, '<br>', '**NOTE:** STUDENT **EXEMPTED** FROM THIS ASSIGNMENT UNTIL FURTHER NOTICE.')
  }
  if(grade$assignment$extra_credit == TRUE){
    capti <- paste0(capti, '<br>', '**NOTE:** THIS ASSIGNMENT IS **EXTRA CREDIT**.')
  }
  if(!is.null(grade$extra_credit)){
    if(grade$extra_credit > 0){
      capti <- paste0(capti, '<br>', '**Note:** extra credit (',grade$extra_credit,' pts) applied.')
    }
  }
  if(grade$penalty > 0){
    capti <- paste0(capti, '<br>', '**NOTE:** this assignment received a **penalty** of ', grade$penalty,'.<br>',
                    '*Cause of penalty* = ', grade$penalty_cause)
  }

  p <- p + labs(title=assi, subtitle=studi, caption= capti)

  #p

  # Feedback plot ==============================================================

  lines <- 0
  if(nchar(grade$feedback)>1){
    (fb <- grade$feedback)
    wrap_width <- 80
    #(chars <- nchar(fb))
    #(returns <- stringr::str_count(fb, '\n'))
    #(lines <- ceiling(chars / wrap_width) + returns)
    fb
    (fbs <- strsplit(fb,'\n')[[1]])
    (fbw <- sapply(fbs, function(x){stringr::str_wrap(x, width=wrap_width)}))
    (fbwb <- gsub('\n', '<br>', fbw))
    (fbf <- paste(fbwb, collapse='<br>'))
    (lines <- stringr::str_count(fbf, '<br>'))

    pf <- ggplot() +
      ggtext::geom_richtext(data=data.frame(x=0,
                                            y=lines,
                                            fbb = fbf),
                            mapping = aes(x=x, y=y, label=fbf),
                            hjust=0,
                            vjust=1,
                            label.colour='white',
                            size=7/.pt) +
      xlim(0,10) +
      ylim(0,lines) +
      theme_minimal() +
      xlab(NULL) + ylab(NULL) +
      theme(axis.text.x=element_blank(), #remove x axis labels
            axis.ticks.x=element_blank(), #remove x axis ticks
            axis.text.y=element_blank(),  #remove y axis labels
            axis.ticks.y=element_blank()  #remove y axis ticks
      ) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

    pf
  }

  # Save ==============================================================

  (n_standards <- nrow(grade$rubric_grades))
  lines
  (total_height <- n_standards + lines)

  (plot_file <- paste0(
    grade$course,'/reports/grades/',
    paste(grade$course,
          grade$assignment$assignment_category,
          grade$assignment$assignment_id,
          grade$student$goes_by,
          sep=' --- '),
    '.pdf'))

  if(lines > 0){
    if(lines > 30){
      (line_ratio <- (3*n_standards) / (lines))
    }else{
      line_ratio <- 5
    }
    reporti <- ggpubr::ggarrange(p, pf, nrow=2,
                                 heights=c(line_ratio,1))
    #reporti
  }else{
    reporti <- p
  }

  grade$report <- list(n_standards = n_standards,
                       feedback_lines = lines,
                       filename = plot_file,
                       report = reporti)

  grade$report
  grade$report$png_name
  grade %>% names
  grade$report %>% names
  grade$report$report

  # Save rendered grade report =================================================

  (ggheight <- (max(c(3.5, 1.1*grade$report$n_standards)) + 0.1*grade$report$feedback_lines))
  if(ggheight > 20){
    ggheight <- .75*ggheight
  }
  ggheight

  ggsave(filename = grade$report$filename,
         plot = grade$report$report,
         width = 7,
         height = ggheight)


  # Update grade file ==========================================================
  # saveRDS(grade, file=grade_file)

}
