#' Launch grading app
#'
#' @param greeting Character vector
#' @param conclusion Character vector
#' @param canned_comments Optional URL (character vector) to a GoogleSheet with canned comments. Two columns in sheet: 'category' and 'comment'
#' @param penalty_choices Character vector of options for explaining a grade penalty, if assigned.
#' @param scroll_height Default height of student scrolling area, in pixels.
#' @param render Default `TRUE` to render each grade's report as a `.PDF` as you work.
#' @param wrap_rubric Character width of rendered rubric lines before wrapping.
#' @param wrap_notes Character width of rendered lines of written feedback notes before wrapping.
#' @param render_ratio The height ratio of the rendered file's rubric section compared to the feedback section.
#' The default is that the former section is 2.25x as tall as the latter.
#' @param ymax_padding An option for adding a bit to the Y axis in order to make room for rubric annotations during PDF render.
#' @param pdf_height The height of the PDF file. If left `NULL`, this will be estimated automatically.
#'
#' @return This function launches a `Shiny` app that lets you grade submissions.
#'
#' @export
#' @import shiny
#' @import dplyr
#' @import shinyjs

grade <- function(greeting = 'Dear STUDENT,\n\nWell-done here. I particularly appreciate \n\nMoving forward, I suggest focusing primarily upon \n',
                  conclusion = '\n\nThank you again, STUDENT, for your hard work.',
                  canned_comments = NULL,
                  penalty_choices=c('N/A', 'Late', 'No submission received', 'Behavior', 'Other'),
                  scroll_height = 200,
                  render = TRUE,
                  wrap_rubric = 30,
                  wrap_notes = 100,
                  render_ratio = 2.25,
                  ymax_padding = .2,
                  pdf_height = 10){

  if(FALSE){
    input <- list(course = 'ENST_209')
    rv <- list()
    setwd( "/Users/ekezell/Library/CloudStorage/GoogleDrive-ekezell@sewanee.edu/My Drive/grades/2023 fall")

    penalty_choices=c('N/A', 'Late', 'Behavior', 'Other')
    greeting = 'Dear STUDENT,\n\nWell-done here. I particularly appreciate \n\nMoving forward, I suggest focusing primarily upon \n'
    conclusion = '\n\nThank you again, STUDENT, for your hard work,\nProf. Ezell'
    canned_comments = 'https://docs.google.com/spreadsheets/d/1vClmqxbC5xhGig7hQyaRjx2rkc2vIUvNUkXXN2v4GOU/edit?usp=sharing'
    canned_comments = NULL
    render = TRUE
    scroll_height = 200
    render = TRUE
    wrap_rubric = 30
    wrap_notes = 100
    render_ratio = 2.25
    ymax_padding = .2
    pdf_height = 10
    grade()
  }
  ##############################################################################
  ##############################################################################

  # Get set of courses
  (courses <- list.dirs('.', recursive=FALSE))
  (courses <- gsub('./', '', courses))
  (courses <- courses[! courses %in% c('.git', '.Rproj.user', 'man', 'R', 'data','z','other', 'img')])

  # Canned comments
  comms_content <- comms_writing <- comms_other <- c()
  if(!is.null(canned_comments)){
    comms <- gsheet::gsheet2tbl(canned_comments)
    (comms_content <- comms %>% filter(category == 'content') %>% pull(comment))
    (comms_writing <- comms %>% filter(category == 'writing') %>% pull(comment))
    (comms_other <- comms %>% filter(category == 'other') %>% pull(comment))
  }

  ##############################################################################
  ##############################################################################

  ui <- fluidPage(
    shinyjs::useShinyjs(),
    htmltools::tags$style(type='text/css', ".selectize-input { font-size: 16px; line-height: 16px;} .selectize-dropdown { font-size: 16px; line-height: 16px; }"),
    htmltools::tags$head(tags$style(HTML("pre { white-space: pre-wrap; word-break: keep-all; }"))),
    shinyalert::useShinyalert(force=TRUE),
    #br(),
    fluidRow(column(12, h5('gradebook'))),
    #hr(),
    sidebarLayout(
      sidebarPanel(
        fluidRow(column(12,
                        selectInput('course', label=h4('Course:'),
                                    choices = courses,
                                    selected=1, width='100%'),
                        uiOutput('assignment'),
                        checkboxInput('offer_feedback', 'Provide written feedback?', value=FALSE, width='100%'),
                        actionButton('get_missing', h6('View missing'), width='100%'),
                        hr(),
                        uiOutput('student'))),
        hr(),
        actionButton('save', h3('Save grade'), width='100%'),
        uiOutput('status'),
        hr(),
        br(),
        shinyWidgets::materialSwitch('exempt', 'Exempt this student?',
                                     value=FALSE, width='100%', status='primary', right=TRUE, inline=FALSE),
        sliderInput('extra_credit', 'Add % extra credit?', min=0, max=100, value=0, step=5, width='100%'),
        sliderInput('penalty', 'Apply % penalty?', min=0, max=100, value=0, step=5, width='100%'),
        selectInput('penalty_why', 'Cause of penalty?', choices=penalty_choices, selected=1, width='100%'),
        br(),
        br(),
        br(),
        sliderInput('pdf_height', label = h6('Set height of PDF (inches)'), value = pdf_height, min = 4, max = 30, step = .5, width = '100%'),
        sliderInput('render_ratio', label = h6('Height ratio of rubric to notes'), value = render_ratio, min = .25, max = 10, step = .1, width = '100%'),
        sliderInput('wrap_rubric', label = h6('Line width of rubric items (in PDF)'), value = wrap_rubric, min = 20, max = 200, step = 1, width = '100%'),
        sliderInput('wrap_notes', label = h6('Line width of notes'), value = wrap_notes, min = 20, max = 200, step = 1, width = '100%'),
        actionButton('view_most_recent', label=h6('View most recent grade report'), width='100%'),
        width=4
      ),

      # Show a plot of the generated distribution
      mainPanel(
        h3('Assessment'),
        fluidRow(column(11, uiOutput('rubric'),
                        hr(),
                        uiOutput('feedback'),
                        uiOutput('preview_text'),
                        uiOutput('feedback_preview_ui'),
                        hr(),
                        textInput('comment', "Comments (for instructor's eyes only)", width='100%')
        ), column(1)),
        br(),
        width=8
      )
    )
  )

  ##############################################################################
  ##############################################################################

  server <- function(input, output, session) {

    #===========================================================================
    # reactive values, part 1

    rv <- reactiveValues()
    rv$status <- NULL
    rv$assignment <- NULL
    rv$student <- NULL
    rv$canned_content <- ''
    rv$canned_writing <- ''
    rv$canned_other <- ''
    rv$feedback_preview <- ''
    rv$comms_content <- comms_content
    rv$comms_writing <- comms_writing
    rv$comms_other <- comms_other
    rv$proceed <- FALSE

    observeEvent(input$course,{
      if(!is.null(input$course) & input$course != ''){
        rv$status <- view_status(input$course)
      }
    })

    #===========================================================================
    # basic UI's

    output$assignment <- renderUI({
      if(!is.null(rv$status)){
        rv$status %>% head
        (asses <- paste0(rv$status$assignment_category, ' --- ', rv$status$assignment_id) %>% unique %>% sort)
        selectInput('assignment', label=h4('Assignment:'),
                    choices = asses, selected=1, width='100%')
      }
    })

    output$student <- renderUI({
      if(!is.null(rv$status) && nrow(rv$status)>0){ #&
        (students <- rv$status$goes_by %>% unique %>% sort)
        if(length(students)>0){
          shinydashboard::box(
            style=paste0('height:', scroll_height,'px; overflow-y: scroll;'),
            shinyWidgets::radioGroupButtons(
              inputId = "student",
              label = NULL,
              choices = students,
              justified = TRUE,
              size = 'lg',
              direction = "vertical",
              width = '100%'
            )
          )
        }
      }
    })

    observeEvent(input$assignment,{
      if(!is.null(input$course) & input$course != '' &
         !is.null(input$assignment) & input$assignment != ''){
        (ass <- paste0(input$course, '/assignments/', input$assignment, '.rds'))
        #print(ass)
        assi <- readRDS(ass)
        rv$assignment <- assi
      }
    })

    observeEvent(input$student,{
      if(!is.null(rv$status) & !is.null(input$student)){
        load(paste0(input$course, '/students.rds'))
        studi <- students %>% filter(goes_by == input$student)
        #print(studi)
        rv$student <- studi[1,]
      }
    })

    output$status <- shiny::renderUI({
      print(input$assignment)
      if(all(!is.null(input$course), !is.null(rv$assignment), !is.null(input$student), !is.null(rv$proceed))){
        assi <- rv$assignment$assignment_id
        print(assi)
        all_grades <- view_grades_quick(input$course, assi)
        print(all_grades)
        if(nrow(all_grades)>0){
          if(input$student %in% all_grades$goes_by){
            (gradefile <- paste0(input$course,'/grades/',input$course,' --- ',input$assignment,' --- ',input$student,'.RData'))
            print(gradefile)
            grade <- readRDS(gradefile)
            helpText(paste0('Grade already on file = ', round(grade$percent,1),'%'))
          }else{
            helpText('No grade on file for this student.')
          }
        }else{
          helpText('No grade on file for this student.')
        }
      }
    })

    observeEvent(input$get_missing, {
      if(!is.null(input$course) & !is.null(input$assignment)){
        missings <- view_missing_quick(input$course, input$assignment)
        #print(missings)
        showModal(modalDialog(
          title = "Missing submissions for this assignment:",
          paste(missings$goes_by, collapse=', '),
          easyClose = TRUE
        ))
      }
    })

    #===========================================================================
    # rubric UI

    output$rubric <- shiny::renderUI({
      #stud <- rv$student
      ass <- rv$assignment
      #if(!is.null(stud) & !is.null(ass)){
      if(!is.null(ass)){
        (rub <- ass$rubric)
        # If rub is NULL, this is a manual grade entry.
        if(is.null(rub)){
          outs = tagList()
          outs[[1]] <- br()
          outs[[2]] <- sliderInput('manual', label='Manual grade entry',
                                   min = 0,
                                   max = as.numeric(rv$assignment$out_of),
                                   value = .8 * as.numeric(rv$assignment$out_of),
                                   step = 0.25,
                                   width = '100%')
          outs[[3]] <- br()
          outs[[4]] <- sliderInput('manual_ec', label='Extra credit?',
                                   min = 0,
                                   max = as.numeric(rv$assignment$out_of),
                                   value = 0,
                                   step = 0.25,
                                   width = '100%')
          outs[[5]] <- br()
          outs

        }else{
          # rubric is NOT null
          x=1
          lapply(1:length(rub),
                 function(x){
                   if(!is.data.frame(rub[[x]])){
                     shiny::fluidRow(column(4, h4(style="text-align: right;",
                                                  HTML(names(rub)[x]))),
                                     column(8))
                   }else{
                     choice_base <- data.frame(rubric_slot=1:5)
                     (choici <- dplyr::left_join(choice_base, rub[[x]], by='rubric_slot'))
                     choici <- choici$description
                     choici <- tidyr::replace_na(choici, '.')
                     choici <- c('N/A', choici[choici!="."])
                     shiny::fluidRow(column(4, p(style="text-align: right;",
                                                 HTML(names(rub)[x]))),
                                     column(8,
                                            shinyWidgets::sliderTextInput(
                                              inputId = paste0('rubric_',x),
                                              label = NULL,
                                              choices = choici,
                                              selected = NULL,
                                              hide_min_max = TRUE,
                                              grid = TRUE,
                                              width = '100%'
                                            )))
                   }
                 })
        }
      }
    })

    #===========================================================================
    # written feedback

    output$feedback <- shiny::renderUI({
      if(input$offer_feedback){
        if(!is.null(canned_comments)){
          fluidRow(
            column(6,
                   h5('Canned comments'),
                   uiOutput('canned_content'),
                   uiOutput('canned_writing'),
                   uiOutput('canned_other'),
                   actionButton('refresh_comments', 'Refresh comments')
            ),
            column(6, uiOutput('feedback_text'))
          )
        }else{
          fluidRow(column(12, uiOutput('feedback_text')))
        }
      }
    })

    observeEvent(input$refresh_comments,{
      comms <- gsheet::gsheet2tbl(canned_comments)
      rv$comms_content <- comms %>% filter(category == 'content') %>% pull(comment)
      rv$comms_writing <- comms %>% filter(category == 'writing') %>% pull(comment)
      rv$comms_other <- comms %>% filter(category == 'other') %>% pull(comment)
    })

    output$canned_content <- shiny::renderUI({
      if(!is.null(rv$student) & !is.null(rv$assignment)){
        if(length(rv$comms_content)>0){
          canned <- c('None',rv$comms_content)
          canned <- rv$comms_content
          selectInput('canned_content', label='re: content', choices = canned, selected = NULL, multiple=TRUE, width='100%')
        }
      }
    })

    output$canned_writing <- shiny::renderUI({
      if(!is.null(rv$student) & !is.null(rv$assignment)){
        if(length(rv$comms_writing)>0){
          canned <- c('None',rv$comms_writing)
          canned <- rv$comms_writing
          selectInput('canned_writing', label='re: writing', choices = canned, selected = NULL, multiple=TRUE, width='100%')
        }
      }
    })

    output$canned_other <- shiny::renderUI({
      if(!is.null(rv$student) & !is.null(rv$assignment)){
        if(length(rv$comms_other)>0){
          canned <- c('None',rv$comms_other)
          canned <- rv$comms_other
          selectInput('canned_other', label='re: other', choices = canned, selected = NULL, multiple=TRUE, width='100%')
        }
      }
    })

    output$preview_text <- shiny::renderUI({
      if(input$offer_feedback){
        h5('Feedback preview:')
      }
    })


    output$feedback_text <- shiny::renderUI({
      if(!is.null(rv$student) & !is.null(rv$assignment)){
        #input$student
        fluidRow(textAreaInput('feedback_pre', 'Custom feedback (before canned comments, if any):',
                               value=greeting,
                               height = '150px',
                               width='100%',
                               resize='vertical'),
                 br(),
                 textAreaInput('feedback_post', 'Custom feedback (after canned comments, if any):',
                               value= conclusion,
                               height = '100px',
                               width='100%',
                               resize='vertical'))
      }
    })


    observe({
      if(input$offer_feedback){
        stud <- rv$student
        if(is.null(stud)){stud <- 'STUDENT'}
        feedback_pre <- gsub('STUDENT', stud, input$feedback_pre)
        feedback_post <- gsub('STUDENT', stud, input$feedback_post)

        canned_content <- ''
        if(!is.null(input$canned_content)){
          if(length(input$canned_content)>1){
            canned_content <- paste0('\n--- ',paste(input$canned_content, collapse='\n--- '))
          }else{
            canned_content <- input$canned_content
          }
          if(nchar(canned_content)>0){canned_content <- paste0('\nIn terms of content: ', canned_content,'\n')}
        }

        canned_writing <- ''
        if(!is.null(input$canned_writing)){
          if(length(input$canned_writing)>1){
            canned_writing <- paste0('\n--- ',paste(input$canned_writing, collapse='\n--- '))
          }else{
            canned_writing <- input$canned_writing
          }
          if(nchar(canned_writing)>0){canned_writing <- paste0('\nRegarding writing: ', canned_writing,'\n')}
        }

        canned_other <- ''
        if(!is.null(input$canned_other)){
          if(length(input$canned_other)>1){
            canned_other <- paste0('\n--- ',paste(input$canned_other, collapse='\n--- '))
          }else{
            canned_other <- input$canned_other
          }
          if(nchar(canned_other)>0){canned_other <- paste0('\nOther notes: ', canned_other,'\n')}
        }

        feedback <- paste0(feedback_pre, canned_content, canned_writing, canned_other, feedback_post)
        rv$feedback_preview <- feedback
      }
    })

    output$feedback_preview_ui <- shiny::renderUI({
      if(input$offer_feedback){
        shiny::wellPanel(verbatimTextOutput('feedback_preview'))
      }
    })

    output$feedback_preview <- shiny::renderText({ rv$feedback_preview })

    # Erase written feedback if checkbox becomes unchecked
    observeEvent(input$offer_feedback, {
      if(input$offer_feedback == FALSE){
        rv$feedback_preview <- ''
      }
    })

    #===========================================================================
    # save

    observeEvent(input$save, {
      stud <- rv$student
      ass <- rv$assignment
      if(!is.null(stud) & !is.null(ass)){
        # Check to see if grade is already on file for this students + assignment
        #course_id <- 'ENST_338'
        #ass <- list(assignment_id <- 'Group case study 1')
        graded <- view_grades_quick(course_id = input$course, assignment_id = ass$assignment_id)
        print(graded)
        (grade_exists <- ifelse(stud$goes_by %in% graded$goes_by, TRUE, FALSE))
        print(grade_exists)

        if(grade_exists){
          modal_confirm <- modalDialog(
            "This student already has a grade on file for this assignment.",
            title = "Grade already exists!",
            footer = tagList(
              actionButton("cancel", "Cancel"),
              actionButton("ok", "Confirm -- overwrite grade!", class = "btn btn-danger")
            ))
          showModal(modal_confirm)
        }else{
          rv$proceed <- TRUE
        }
      }
    })

    observeEvent(input$ok, {
      removeModal()
      rv$proceed <- TRUE
    })

    observeEvent(input$cancel, {
      removeModal()
    })

    observeEvent(rv$proceed,{
      if(rv$proceed == TRUE){
        (stud <- rv$student)
        (ass <- rv$assignment)
        (rub <- ass$rubric)

        if(is.null(rub)){
          # No rubric -- manual grade entry
          manual_grade <- as.numeric(input$manual) + as.numeric(input$manual_ec)

          rubric_grades <- data.frame(standard = 'Manual grade entry',
                                      decision = '',
                                      # add manual grade entry here
                                      percent = round(100*(as.numeric(input$manual) / rv$assignment$out_of), 3),
                                      letter = '')
        }else{
          # Yes rubric
          (rubric_items <- names(rub))

          # Harvest inputs
          inputs <- shiny::reactiveValuesToList(input) # get list of all inputs

          # Inventory rubric grades
          rubric_grades <- data.frame()
          i=1
          for(i in 1:length(rub)){
            (standard <- names(rub)[i]) #%>% print
            (rub_content <- rub[[i]])  #%>% print
            decision <- 'category'
            letter <- percent <- NA
            if(is.data.frame(rub_content)){
              (input_name <- paste0('rubric_',i))
              (matchi <- which(names(inputs)==input_name)) #%>% print
              (decision <- inputs[[matchi]]) #%>% print
              (assi <- which(rub_content$description == decision)) #%>% print
              if(length(assi)>0){
                letter <- rub_content$letter[assi]
                percent <- rub_content$percent[assi]
              }
            }
            (rubric_gradi <- data.frame(standard, decision, percent, letter)) #%>% print
            rubric_grades <- rbind(rubric_grades, rubric_gradi)
          }

          print(rubric_grades)
        } # end of if there was a rubric

        # Initiate grade list
        grade <- list(course = input$course,
                      assignment = rv$assignment,
                      student = rv$student,
                      rubric_grades = rubric_grades,
                      feedback = rv$feedback_preview,
                      exemption = input$exempt, # if TRUE, do not include in final grade
                      extra_credit = input$extra_credit,
                      penalty = round(input$penalty/100, 2), #
                      penalty_cause = input$penalty_why,
                      shared = FALSE,
                      internal_comment = input$comment,
                      date_graded = as.character(Sys.time()))

        # Calculate score
        if(grade$exemption){
          grade$percent <- NA
          grade$points <- NA
          grade$out_of <- NA
        }else{
          grade$percent <- round(mean(rubric_grades$percent, na.rm=TRUE)*(1 - grade$penalty), 5) + input$extra_credit
          grade$points <- round(((grade$percent / 100) * grade$assignment$out_of), 5)
        }
        print(grade)

        # Handle 100% penalties when no rubric info is filled out
        if(is.na(grade$percent) & is.na(grade$points) & grade$penalty == 1){
          grade$percent <- 0
          grade$points <- 0
        }

        message('Exemption status: ', grade$exemption)

        # Prep filename
        grade_fn <- paste0(grade$course, '/grades/',
                           grade$course, ' --- ',
                           grade$assignment$assignment_category, ' --- ',
                           grade$assignment$assignment_id, ' --- ',
                           grade$student$goes_by,'.RData')
        print(grade_fn)

        # Most recent
        www_fn <- 'www/most_recent.RData'

        # Save grade
        saveRDS(grade, file=grade_fn)
        saveRDS(grade, file=www_fn)
        print('grade saved!')

        # Render grade report
        if(grade$exemption == FALSE){
          # Official
          render_grade(grade_fn,
                       wrap_rubric = input$wrap_rubric,
                       wrap_notes = input$wrap_notes,
                       render_ratio = input$render_ratio,
                       pdf_height = input$pdf_height)

          # For viewing the most recent
          render_grade(www_fn,
                       wrap_rubric = input$wrap_rubric,
                       wrap_notes = input$wrap_notes,
                       render_ratio = input$render_ratio,
                       pdf_height = input$pdf_height)

          print('report generated!')
        }

        # Show modal dialog
        shinyalert::shinyalert(text = "Grade saved!", closeOnClickOutside = TRUE,
                               showCancelButton = FALSE, showConfirmButton = FALSE,
                               timer = 800, animation = FALSE, size = "s", immediate = TRUE)

        # Reset values
        shinyjs::reset("exempt")
        rv$proceed <- FALSE

      }}) # end save reactive

    #===========================================================================
    # View most recent grade report

    output$pdfview <- renderUI({
      tags$iframe(style="height:600px; width:100%", src="pdfpath/most_recent.pdf")
    })

    observeEvent(input$view_most_recent, {
      showModal(modalDialog(
        uiOutput('pdfview'),
        easyClose = TRUE
      ))
    })

  }

  ##############################################################################
  ##############################################################################
  (mypath <- paste0(getwd(),'/www'))
  shiny::addResourcePath(prefix='pdfpath', directoryPath=mypath)

  shinyApp(ui, server)
}
