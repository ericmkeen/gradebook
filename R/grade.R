#' Launch grading app
#'
#' @param penalty_choices Character vector of options for explaining a grade penalty, if assigned.
#' @param greeting Character vector
#' @param conclusion Character vector
#' @param canned_comments Optional URL (character vector) to a GoogleSheet with canned comments. Two columns in sheet: 'category' and 'comment'
#' @param render Default `TRUE` to render each grade's report as a `.PDF` as you work.
#'
#' @return This function launches a `Shiny` app that lets you grade submissions.
#'
#' @export
#' @import shiny
#' @import dplyr
#' @import shinyjs

grade <- function(penalty_choices=c('N/A', 'Late', 'Behavior', 'Other'),
                  greeting = 'Dear STUDENT,\n\nWell-done here. I particularly appreciate \n\nMoving forward, I suggest focusing primarily upon \n',
                  conclusion = '\n\nThank you again, STUDENT, for your hard work,\nProf. Ezell',
                  canned_comments = NULL,
                  render = TRUE){

  if(FALSE){
    penalty_choices=c('N/A', 'Late', 'Behavior', 'Other')
    greeting = 'Dear STUDENT,\n\nWell-done here. I particularly appreciate \n\nMoving forward, I suggest focusing primarily upon \n'
    conclusion = '\n\nThank you again, STUDENT, for your hard work,\nProf. Ezell'
    canned_comments = 'https://docs.google.com/spreadsheets/d/1vClmqxbC5xhGig7hQyaRjx2rkc2vIUvNUkXXN2v4GOU/edit?usp=sharing'
    render = TRUE
  }
  ##############################################################################
  ##############################################################################

  # Get set of courses
  (courses <- list.dirs('.', recursive=FALSE))
  (courses <- gsub('./', '', courses))
  (courses <- courses[! courses %in% c('.git', '.Rproj.user', 'man', 'R', 'data','z','other')])

  # Canned comments
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
    #br(),
    fluidRow(column(12, h5('gradebook'))),
    #hr(),
    sidebarLayout(
      sidebarPanel(
        selectInput('course', label=h4('Course:'),
                    choices = courses, selected=1, width='100%'),
        uiOutput('assignment'),
        uiOutput('student'),
        hr(),
        #### ADD check/filter about whether or not grade already exists
        shinyWidgets::materialSwitch('exempt', 'Exempt this student?',
                                     value=FALSE, width='100%', status='primary', right=TRUE, inline=FALSE),
        sliderInput('penalty', 'Apply % penalty?', min=0, max=100, value=0, step=5, width='100%'),
        selectInput('penalty_why', 'Cause of penalty?', choices=penalty_choices, selected=1, width='100%'),
        br(),
        checkboxInput('filter', 'Filter to students not-yet graded?', value=FALSE, width='100%'),
        checkboxInput('offer_feedback', 'Provide written feedback?', value=FALSE, width='100%'),
        hr(),
        actionButton('save', h3('Save grade'), width='100%'),
        br(), br(),
        #actionButton('clear', h3('Clear / reset'), width='100%'),
        width=3
      ),

      # Show a plot of the generated distribution
      mainPanel(
        h3('Assessment'),
        fluidRow(column(11, uiOutput('rubric'),
                        hr(),
                        uiOutput('feedback'),
                        uiOutput('preview_text'),
                        verbatimTextOutput('feedback_preview'),
                        hr(),
                        textInput('comment', "Comments (for instructor's eyes only)", width='100%')
        ), column(1)),
        br(),
        width=9
      )
    )
  )

  ##############################################################################
  ##############################################################################

  server <- function(input, output, session) {

    #===========================================================================
    # basic UI's

    output$assignment <- renderUI({
      if(!is.null(input$course)){
        (asses <- dir(paste0(input$course, '/assignments')))
        asses <- gsub('.rds','',asses)
        selectInput('assignment', label=h4('Assignment:'),
                    choices = asses, selected=1, width='100%')
      }
    })

    output$student <- renderUI({
      if(!is.null(input$course) &
         !is.null(input$assignment)){
        students <- view_students(input$course)
        if(input$filter & nrow(rv$grade_status) > 0){
          gradi <- rv$grade_status %>% filter(assignment_id == input$assignment, graded == FALSE)
          if(nrow(gradi)>0){
            students <- students %>% filter(goes_by %in% gradi$student)
          }else{
            students <- data.frame()
          }
        }
        if(nrow(students)>0){
          selectInput('student', label=h4('Student:'),
                      choices = sort(students$goes_by),
                      selected=1, width='100%',
                      selectize = FALSE,
                      multiple = FALSE,
                      size = 5)
        }
      }
    })

    #===========================================================================
    # reactive values

    rv <- reactiveValues()
    rv$assignment <- NULL
    rv$student <- NULL
    rv$canned_content <- ''
    rv$canned_writing <- ''
    rv$canned_other <- ''
    rv$feedback_preview <- ''
    rv$grade_status <- data.frame()

    observeEvent(input$assignment,{
      if(!is.null(input$course) & input$course != '' &
         !is.null(input$assignment) & input$assignment != ''){
        (ass <- paste0(input$course, '/assignments/', input$assignment, '.rds'))
        assi <- readRDS(ass)
        rv$assignment <- assi

        # Update grade status dataframe
        rv$grade_status <- view_status(course_id = input$course)
      }
    })

    observeEvent(input$student,{
      if(!is.null(input$student)){
        load(paste0(input$course, '/students.rds'))
        studi <- students %>% filter(goes_by == input$student)
        #print(studi)
        rv$student <- studi[1,]
      }
    })

    #===========================================================================
    # rubric UI

    output$rubric <- shiny::renderUI({
      stud <- rv$student
      ass <- rv$assignment
      if(!is.null(stud) & !is.null(ass)){
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
                                            #br(),
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
        fluidRow(
          column(6,
                 h5('Canned comments'),
                 uiOutput('canned_content'),
                 uiOutput('canned_writing'),
                 uiOutput('canned_other')
          ),
          column(6, uiOutput('feedback_text'))
        )
      }
    })

    output$canned_content <- shiny::renderUI({
      if(!is.null(rv$student) & !is.null(rv$assignment)){
        if(length(comms_content)>0){
          canned <- c('None',comms_content)
          canned <- comms_content
          selectInput('canned_content', label='re: content', choices = canned, selected = NULL, multiple=TRUE, width='100%')
        }
      }
    })

    output$canned_writing <- shiny::renderUI({
      if(!is.null(rv$student) & !is.null(rv$assignment)){
        if(length(comms_writing)>0){
          canned <- c('None',comms_writing)
          canned <- comms_writing
          selectInput('canned_writing', label='re: writing', choices = canned, selected = NULL, multiple=TRUE, width='100%')
        }
      }
    })

    output$canned_other <- shiny::renderUI({
      if(!is.null(rv$student) & !is.null(rv$assignment)){
        if(length(comms_other)>0){
          canned <- c('None',comms_other)
          canned <- comms_other
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
        fluidRow(textAreaInput('feedback_pre', 'Custom feedback (before canned comments):',
                               value=greeting,
                               height = '150px',
                               width='100%',
                               resize='vertical'),
                 br(),
                 textAreaInput('feedback_post', 'Custom feedback (after canned comments):',
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

    output$feedback_preview <- shiny::renderText({ if(input$offer_feedback){ rv$feedback_preview } })


    #===========================================================================
    # save

    observeEvent(input$save, {
      stud <- rv$student
      ass <- rv$assignment
      if(!is.null(stud) & !is.null(ass)){
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
                      penalty = round(input$penalty/100, 2), #
                      penalty_cause = input$penalty_cause,
                      shared = FALSE,
                      internal_comment = input$comment,
                      date_graded = as.character(Sys.time()))

        # Calculate score
        if(grade$exemption){
          grade$percent <- NA
          grade$points <- NA
          grade$out_of <- NA
        }else{
          grade$percent <- round(mean(rubric_grades$percent, na.rm=TRUE)*(1 - grade$penalty), 5)
          grade$points <- round(((grade$percent / 100) * grade$assignment$out_of), 5)
        }
        print(grade)

        message('Exemption status: ', grade$exemption)

        # Prep filename
        grade_fn <- paste0(grade$course, '/grades/',
                           grade$course, ' --- ',
                           grade$assignment$assignment_category, ' --- ',
                           grade$assignment$assignment_id, ' --- ',
                           grade$student$goes_by,'.RData')
        print(grade_fn)

        # Save grade
        saveRDS(grade, file=grade_fn)
        print('grade saved!')

        # Render grade repor
        if(grade$exemption == FALSE){
          render_grade(grade_fn)
          print('report generated!')
        }

        # Show modal dialog
        shinyalert::shinyalert(text = "Grade saved!", closeOnClickOutside = TRUE,
                               showCancelButton = FALSE, showConfirmButton = FALSE,
                               timer = 800, animation = FALSE, size = "s", immediate = TRUE)

        # Update grade status dataframe
        rv$grade_status <- view_status(course_id = input$course)
        print('grade status updated!')
        print(rv$grade_status)

        # Reset values
        shinyjs::reset("exempt")

      }
    })

    #===========================================================================


  }

  ##############################################################################
  ##############################################################################

  shinyApp(ui, server)
}