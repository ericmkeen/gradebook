################################################################################
################################################################################
# ENST 209 setup
################################################################################
################################################################################

# Set course ID
course_id <- 'ENST_209'

# Students
students_url <- 'https://docs.google.com/spreadsheets/d/1H4PPmKESpXVsy93QUbU0WhVpqRbg2x-V77EIY0NH0zw/edit?usp=sharing'
update_roster('ENST_209', students_url) # rerun this each time your googlesheet is changed

# Quick view of students
view_students('ENST_209')

################################################################################
################################################################################
# Assignments
################################################################################
################################################################################

data(grade_scale1) ; grade_scale1
data(grade_scale2) ; grade_scale2
data(grade_scale3) ; grade_scale3

# Reading quizzes ==============================================================

course_id <- 'ENST_209'
ass_cat <- 'Reading quiz'
out_of <- 3
rq_rubric <- NULL

# Week 2 08.28
assignment(course_id = course_id, assignment_id = 'Week 02 Monday quiz',
  assignment_category = ass_cat, out_of = out_of, due_date = '2023-08-28',
  share = FALSE, rubric = rq_rubric)

assignment(course_id = course_id, assignment_id = 'Week 02 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-08-30',
           share = FALSE, rubric = rq_rubric)

# Week 3 9.4
assignment(course_id = course_id, assignment_id = 'Week 03 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-04',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 03 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-06',
           share = FALSE, rubric = rq_rubric)

# Week 4 9.11
assignment(course_id = course_id, assignment_id = 'Week 04 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-11',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 04 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-13',
           share = FALSE, rubric = rq_rubric)

# Week 5 9.18
assignment(course_id = course_id, assignment_id = 'Week 05 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-18',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 05 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-20',
           share = FALSE, rubric = rq_rubric)

# Week 6 9.25
assignment(course_id = course_id, assignment_id = 'Week 06 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-25',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 06 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-27',
           share = FALSE, rubric = rq_rubric)

# Week 7 10.2
assignment(course_id = course_id, assignment_id = 'Week 07 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-02',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 07 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-04',
           share = FALSE, rubric = rq_rubric)

# Week 8 10.9
assignment(course_id = course_id, assignment_id = 'Week 08 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-09',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 08 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-11',
           share = FALSE, rubric = rq_rubric)

# Week 9 10.16
# No Monday quiz (Fall Break)
assignment(course_id = course_id, assignment_id = 'Week 09 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-18',
           share = FALSE, rubric = rq_rubric)

# Week 10 10.23
assignment(course_id = course_id, assignment_id = 'Week 10 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-23',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 10 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-25',
           share = FALSE, rubric = rq_rubric)

# Week 11 10.30
assignment(course_id = course_id, assignment_id = 'Week 11 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-30',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 11 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-01',
           share = FALSE, rubric = rq_rubric)

# Week 12 11.6
assignment(course_id = course_id, assignment_id = 'Week 12 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-06',
           share = FALSE, rubric = rq_rubric)
assignment(course_id = course_id, assignment_id = 'Week 12 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-08',
           share = FALSE, rubric = rq_rubric)

# Week 13 11.13
# No reading quiz Monday -- Podcast due instead
assignment(course_id = course_id, assignment_id = 'Week 13 Wednesday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-15',
           share = FALSE, rubric = rq_rubric)

# Week 14 11.20
assignment(course_id = course_id, assignment_id = 'Week 14 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-20',
           share = FALSE, rubric = rq_rubric)
# No Wednesday quiz -- Thanksgiving break

# Week 15 11.27
# No Monday quiz -- Thanksgiving break
# No Wednesday quiz

# Week 16 12.4
assignment(course_id = course_id, assignment_id = 'Week 16 Monday quiz',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-12-04',
           share = FALSE, rubric = rq_rubric)
# No Wednesday quiz


# Weekly exam submissions ======================================================

course_id <- 'ENST_209'
ass_cat <- 'Exam response'
out_of <- 3
response_rubric <- NULL
#(response_rubric <- list('Submission seems complete and on-topic' = grade_scale2))

# Week 2 due 9.8
assignment(course_id = course_id, assignment_id = 'Week 02 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-08',
           share = TRUE, rubric = response_rubric)

# Week 3 due 9.15
assignment(course_id = course_id, assignment_id = 'Week 03 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-15',
           share = TRUE, rubric = response_rubric)

# Week 4 due 9.22
assignment(course_id = course_id, assignment_id = 'Week 04 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-22',
           share = TRUE, rubric = response_rubric)

# Week 5 due 9.29
assignment(course_id = course_id, assignment_id = 'Week 05 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-29',
           share = TRUE, rubric = response_rubric)

# Week 6 (no exam response; film response instead)

# Week 7 due 10.13
assignment(course_id = course_id, assignment_id = 'Week 07 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-13',
           share = TRUE, rubric = response_rubric)

# Week 8 due 10.20
assignment(course_id = course_id, assignment_id = 'Week 08 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-20',
           share = TRUE, rubric = response_rubric)

# Week 9 (no exam response; film response instead)

# Week 10 due 11.3
assignment(course_id = course_id, assignment_id = 'Week 10 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-03',
           share = TRUE, rubric = response_rubric)

# Week 11 due 11.10
assignment(course_id = course_id, assignment_id = 'Week 11 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-10',
           share = TRUE, rubric = response_rubric)

# Week 12 due 11.17
assignment(course_id = course_id, assignment_id = 'Week 12 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-17',
           share = TRUE, rubric = response_rubric)

# Week 13 due 12.1
assignment(course_id = course_id, assignment_id = 'Week 13 response',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-12-01',
           share = TRUE, rubric = response_rubric)


# Conservation briefs ===========================================================

(brief_rubric <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                     'Talk is <b>engaging, info-dense, efficient</b>, carefully designed, and accurate' = grade_scale1,
                     "<b>A strategic synthesis of the most important content:</b> each section is covered, with a proper balance of overview & detail."=grade_scale1,
                     'Talk includes <b>recent news & the most promising solutions</b>.'=grade_scale1,
                     'The talk is clearly <b>well-planned & thoroughly-rehearsed</b>.' = grade_scale1,
                     '<b>Time allocation</b>: the talk is 5 minutes long exactly, followed by 10 minutes of activity/discussion.' = grade_scale1,
                     '<b>Visual aides</b> are well-prepared, useful, info-rich & professional.' = grade_scale1,
                     '<b>Discussion/activity</b> is creative, engaging, & provocative. The class feels energized, safe, and eager to participate.' = grade_scale1,
                     '<b>Equal participation</b> by all team members, in both prep and delivery.' = grade_scale1,
                     '<b>Adherence to instructions.</b>' = grade_scale3))

assignment(course_id = course_id,
           assignment_id = 'Brief 1',
           assignment_category = 'Conservation Brief',
           out_of = 15,
           due_date = '2023-11-01',
           share = TRUE,
           rubric = brief_rubric)

assignment(course_id = course_id,
           assignment_id = 'Brief 2',
           assignment_category = 'Conservation Brief',
           out_of = 15,
           due_date = '2023-12-06',
           share = TRUE,
           rubric = brief_rubric)


# Film responses  ==============================================================

(film_rubric <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                    '<b>Film details are included throughout,</b> clearly well-understood.' = grade_scale1,
                    '<b>Concepts are explained well & clearly,</b> with attention to word-choice and order of ideas.' = grade_scale1,
                    'An <b>original & engaging thesis</b> and a <b>persuasive argument</b> for that thesis.'= grade_scale1,
                    '<b>Writing is concise, exact, & clear.</b> Conceptual flow is intuitive & straightforward.' = grade_scale1,
                    '<b>Writing is polished and error-free.</b>' = grade_scale3,
                    '<b>Adherence to instructions.</b>' = grade_scale3))

ass_cat <- 'Film response'
out_of <- 15

assignment(course_id = course_id, assignment_id = 'Film response 1',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-06',
           share = TRUE, rubric = film_rubric)

assignment(course_id = course_id, assignment_id = 'Film response 2',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-27',
           share = TRUE, rubric = film_rubric)


# Book podcast =================================================================

(book_rubric <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                     '<b>Book details are included throughout,</b> clearly closely-read & well-understood.' = grade_scale1,
                     '<b>Concepts are explained well & clearly,</b> with attention to word-choice and order of ideas.' = grade_scale1,
                     'The podcast transcript is <b>creative, original, fun, & thought-provoking</b>.'= grade_scale1,
                     '<b>Writing/speaking is concise, exact, & clear.</b> Conceptual flow is intuitive & straightforward.' = grade_scale1,
                     '<b>Writing/speaking is polished and error-free.</b>' = grade_scale3,
                     '<b>Adherence to instructions.</b>' = grade_scale3))

ass_cat <- 'Book podcast'
out_of <- 15

assignment(course_id = course_id,
           assignment_id = 'Book podcast',
           assignment_category = ass_cat,
           out_of = out_of,
           due_date = '2023-11-13',
           share = TRUE, rubric = book_rubric)


# Exam on lectures =============================================================

(exam_rubric <- list('<b>Response is detailed & thorough,</b> addressing all aspects of prompt.' = grade_scale1,
                     '<b>Details provided are correct.</b>' = grade_scale1,
                     '<b>Impressive demonstration of expertise & nuanced understanding.</b>' = grade_scale1,
                     '<b>Concepts are explained well & clearly,</b> with attention to word-choice and order of ideas.' = grade_scale1,
                     '<b>Writing is concise, exact, & clear.</b> Conceptual flow is intuitive & straightforward.' = grade_scale1,
                     '<b>Writing is polished and error-free.</b>' = grade_scale3,
                     '<b>Adherence to instructions.</b>' = grade_scale3))

out_of <- 10

assignment(course_id = course_id,
           assignment_id = 'Presubmission',
           assignment_category = 'Exam on lectures',
           out_of = out_of,
           due_date = '2023-12-6',
           share = TRUE,
           rubric = exam_rubric)

assignment(course_id = course_id,
           assignment_id = 'Live in class',
           assignment_category = 'Exam on lectures',
           out_of = out_of,
           due_date = '2023-12-6',
           share = TRUE,
           rubric = exam_rubric)


# Final exam on Conservation Briefs -- TBD =====================================

(brief_exam_rubric <-
   list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
        '<b>Response is detailed & thorough,</b> addressing all aspects of prompt.' = grade_scale1,
        '<b>Details provided are correct.</b>' = grade_scale1,
        '<b>Impressive demonstration of expertise & nuanced understanding.</b>' = grade_scale1,
        '<b>Concepts are explained well & clearly,</b> with attention to word-choice and order of ideas.' = grade_scale1,
        '<b>Writing is concise, exact, & clear.</b> Conceptual flow is intuitive & straightforward.' = grade_scale1,
        '<b>Writing is polished and error-free.</b>' = grade_scale3,
        '<b>Adherence to instructions.</b>' = grade_scale3))

out_of <- 15

assignment(course_id = course_id,
           assignment_id = 'Take home portion',
           assignment_category = 'Final exam',
           out_of = out_of,
           due_date = '2023-12-10',
           share = TRUE,
           rubric = brief_exam_rubric)

assignment(course_id = course_id,
           assignment_id = 'Live portion',
           assignment_category = 'Final exam',
           out_of = out_of,
           due_date = '2023-12-10',
           share = TRUE,
           rubric = brief_exam_rubric)


################################################################################
################################################################################
# Syllabus prep
################################################################################
################################################################################

plot_assignment_calendar(course_id)

plot_assignment_weights(course_id)


################################################################################
################################################################################
# Grade & manage
################################################################################
################################################################################

# Grade
grade()

# QA/QC
view_assignments('ENST_209') # View simple list of assignments
view_status('ENST_209') # get a master list of all assignments on file and the grades that are already complete.
view_missing('ENST_209') # are any students without a grade for an assignment that was already due?
render_grades('ENST_209') # Re-render grade reports in a batch, if needed (helpful it modifying the ggplot code)

# Share grades =================================================================

view_unshared('ENST_209') # Return which grades have not yet been shared

email_grades(course_id = 'ENST_209',
             unshared_only = TRUE,
             your_email = 'ekezell@sewanee.edu',
             json_path = '/Users/erickeen/repos/credentials/desktop_gradebook.json')


# Reports ======================================================================

render_student('ENST_209',
               'Student 2')

render_class('ENST_209')









