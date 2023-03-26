gradebook <- function(penalty_choices=c('N/A', 'Late', 'Behavior', 'Other')){

  ##############################################################################
  ##############################################################################

  # Get set of courses
  (courses <- list.dirs('.', recursive=FALSE))
  (courses <- gsub('./', '', courses))
  (courses <- courses[! courses %in% c('.git', '.Rproj.user', 'man', 'R')])

  ##############################################################################
  ##############################################################################

  ui <- fluidPage(
    shinyjs::useShinyjs(),
    br(),
    fluidRow(column(12, h2('gradebook'))),
    hr(),
    fluidRow(
      column(4, uiOutput('course')),
      column(4, uiOutput('assignment')),
      column(4, uiOutput('student'))),
    hr(),
    #### ADD check about whether or not grade already exists
    fluidRow(column(3, shinyWidgets::materialSwitch('exempt', 'Exempt student from assignment?', value=FALSE, width='100%', status='primary', right=TRUE, inline=FALSE)),
             column(4,  sliderInput('penalty', 'Apply % penalty?', min=0, max=100, value=0, step=5, width='100%')),
             column(5, selectInput('penalty_why', 'Cause of penalty?', choices=penalty_choices, selected=1, width='100%'))),
    hr(),
    fluidRow(column(12, h3('Rubric'))),
    fluidRow(column(12, uiOutput('rubric'))),
    hr(),
    fluidRow(column(12, 'written feedback')),
    hr(),
    fluidRow(column(12, textInput('comment', 'Comments (for instructor)', width='100%'))),
    hr(),
    fluidRow(column(6, actionButton('save', h3('Save grade'), width='100%')),
             column(6, actionButton('clear', h3('Clear / reset'), width='100%'))),
    br()
  )

  ##############################################################################
  ##############################################################################

  server <- function(input, output, session) {

    #===========================================================================
    # basic UI's

    output$course <- renderUI({
      selectInput('course', label=h4('Course:'),
                choices = courses, selected=1, width='100%')
    })

    output$assignment <- renderUI({
      (asses <- dir(paste0(input$course, '/assignments')))
      asses <- gsub('.rds','',asses)
      #print(asses)
      selectInput('assignment', label=h4('Assignment:'),
                  choices = asses, selected=1, width='100%')
    })

    output$student <- renderUI({
      if(!is.null(input$course)){
        load(paste0(input$course, '/students.rds'))
        #print(students$goes_by)
        selectInput('student', label=h4('Student:'),
                    choices = students$goes_by, selected=1, width='100%')
      }
    })

    #===========================================================================
    # reactive values

    rv <- reactiveValues()
    rv$assignment <- NULL
    rv$student <- NULL

    observeEvent(input$assignment,{
      if(!is.null(input$assignment) & input$assignment != ''){
        (ass <- paste0(input$course, '/assignments/', input$assignment, '.rds'))
        #ass <- "ENST_320/assignments/R workshop --- #1 Carbon emissions.rds"
        #print(ass)
        assi <- readRDS(ass)
        #print(assi)
        rv$assignment <- assi
      }
    })

    observeEvent(input$student,{
      if(!is.null(input$student)){
        load(paste0(input$course, '/students.rds'))
        studi <- students %>% filter(goes_by == input$student)
        #print(studi)
        rv$student <- studi
      }
    })

    #===========================================================================
    # rubric UI

    output$rubric <- shiny::renderUI({
      stud <- rv$student
      ass <- rv$assignment
      if(!is.null(stud) & !is.null(ass)){
        #(ass <- readRDS("ENST_320/assignments/R workshop --- #1 Carbon emissions.rds"))
        (rub <- ass$rubric)

        x=1
        lapply(1:length(rub),
               function(x){
                 choice_base <- data.frame(letter=c('F', 'D', 'C', 'B', 'A'))
                 (choici <- dplyr::left_join(choice_base, rub[[x]], by='letter'))
                 choici <- choici$description
                 choici <- tidyr::replace_na(choici, ' ')
                 choici <- c('N/A', choici)
                 shiny::fluidRow(column(2, h4(names(rub)[x])),
                                 column(10, br(),
                                        shinyWidgets::prettyRadioButtons(paste0('rubric_',x),
                                                         label=NULL,
                                                         choices=choici,
                                                         selected = 'N/A',
                                                         inline = TRUE,
                                                         bigger=TRUE)
                                        ))
             })
      }
    })

    #===========================================================================
    # save

    observeEvent(input$save, {
      stud <- rv$student
      ass <- rv$assignment
      if(!is.null(stud) & !is.null(ass)){
        #(ass <- readRDS("ENST_320/assignments/R workshop --- #1 Carbon emissions.rds"))
        (rub <- ass$rubric)
        (rubric_items <- names(rub))

        # Harvest inputs
        inputs <- shiny::reactiveValuesToList(input) # get list of all inputs
        rubi <- inputs[grepl('rubric', names(inputs))] %>% unlist # subset to rubric inputs
        rubi <- rubi[order(names(rubi))]
        #print(rubi)

        # Inventory rubric grades
        #rubi <- c('Critical issues', 'Focus on improving', 'Strong/good')
        i=1
        rubric_grades <- data.frame()
        for(i in 1:length(rubi)){
          (decision <- rubi[i])
          (standard <- names(ass$rubric)[[i]])
          (ass_details <- ass$rubric[[i]])
          (assi <- which(ass_details$description == decision))
          if(length(assi)==0){
            letter <- NA
            percent <- NA
          }else{
              letter <- ass_details$letter[assi]
              percent <- ass_details$percent[assi]
          }
          rubric_gradi <- data.frame(standard, decision, percent, letter)
          rubric_grades <- rbind(rubric_grades, rubric_gradi)
        }
        #print(rubric_grades)

        # Initiate grade list
        grade <- list(course = input$course,
                      assignment = rv$assignment,
                      student = rv$student,
                      rubric_grades = rubric_grades,
                      feedback = NULL, # placeholder
                      exemption = input$exempt, # if TRUE, do not include in final grade
                      penalty = round(input$penalty/100, 2), #
                      penalty_cause = input$penalty_cause,
                      shared = FALSE,
                      comment = input$comment,
                      date_graded = as.character(Sys.time()))

        # Calculate score
        if(grade$exemption){
          grade$percent <- NA
          grade$points <- NA
          grade_out_of <- NA
        }else{
          grade$percent <- round(mean(rubric_grades$percent, na.rm=TRUE)*(1 - grade$penalty), 5)
          grade$points <- round(((grade$percent / 100) * grade$assignment$out_of), 5)
        }
        print(grade)

        # Prep filename
        grade_fn <- paste0(grade$course, '/grades/',
                           grade$assignment$assignment_category, '---',
                           grade$assignment$assignment_id, '---',
                           grade$student$goes_by,'.RData')
        print(grade_fn)

        # Save grade
        saveRDS(grade, file=grade_fn)

        # ADD DIALOG MESSAGE IN SHINY APP HERE -- CONFIRMATION
      }

    })

    #===========================================================================


  }

  ##############################################################################
  ##############################################################################

  shinyApp(ui, server)
}

library(shiny)
library(shinyjs)
library(dplyr)
gradebook()

