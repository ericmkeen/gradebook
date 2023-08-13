################################################################################
################################################################################
# ENST 209 setup
################################################################################
################################################################################

# Set course ID
course_id <- 'ENST_101'

# Students
students_url <- 'https://docs.google.com/spreadsheets/d/1RxRhZeazRuG9yUBHBWlzLwNuC__Mbs7pVH2V55_UeWc/edit?usp=sharing'
update_roster('ENST_101', students_url) # rerun this each time your googlesheet is changed

# Quick view of students
view_students('ENST_101')

################################################################################
################################################################################
# Assignments
################################################################################
################################################################################

data(grade_scale1) ; grade_scale1
data(grade_scale2) ; grade_scale2
data(grade_scale3) ; grade_scale3

# Reading quizzes ==============================================================

course_id <- 'ENST_101'
ass_cat <- 'Module quiz'
out_of <- 10
rubric <- NULL
share <- TRUE

assignment(course_id = course_id, assignment_id = 'Week 02 Sustainability',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-08-30',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 03 Ecological rules',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-06',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 04 Food background',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-13',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 05 Food issues',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-20',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 06 Food solutions',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-27',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 07 Water',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-04',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 08 Shelter',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-11',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 10 Biodiversity',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-25',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 11 Climate issues',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-01',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 12 Climate solutions',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-08',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 13 Consumption',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-15',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 15 All modules',
           assignment_category = ass_cat, out_of = out_of*2, due_date = '2023-11-29',
           share = share, rubric = rubric)


# Journals =====================================================================

course_id <- 'ENST_101'
ass_cat <- 'Journal'
out_of <- 5
rubric <- NULL
share <- TRUE

assignment(course_id = course_id, assignment_id = 'Week 02 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-08-30',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 03 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-06',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 04 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-13',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 05 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-20',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 06 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-09-27',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 07 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-04',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 08 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-11',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 09 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-18',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 10 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-10-25',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 11 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-01',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 12 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-08',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 13 journal',
           assignment_category = ass_cat, out_of = out_of, due_date = '2023-11-15',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_id = 'Week 15 journal',
           assignment_category = ass_cat, out_of = out_of*2, due_date = '2023-11-29',
           share = share, rubric = rubric)


# News desks ===================================================================

(news_rubric <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                      'Talk is <b>engaging, info-dense, efficient</b>, carefully designed, and accurate' = grade_scale1,
                      "<b>A strategic synthesis of the most important content:</b> topics are covered a proper balance of overview & detail."=grade_scale1,
                      'The talk is clearly <b>well-planned & thoroughly-rehearsed</b>, with only minor reliance upon notes.' = grade_scale1,
                      '<b>Time allocation</b>: the talk is 3 to 4 minutes long, no more and no less.' = grade_scale1,
                      '<b>Visual aides</b> are well-prepared, useful, info-rich & professional. They are not text-heavy and <b> the speaker does not read off the slides</b>.' = grade_scale1,
                      '<b>Adherence to instructions for the respesctive news desk.</b>' = grade_scale3))

assignment(course_id = course_id,
           assignment_category = 'News brief',
           assignment_id = 'News brief 1',
           out_of = 15,
           due_date = '2023-11-01', # arbitrary
           share = TRUE,
           extra_credit = FALSE,
           rubric = news_rubric)

assignment(course_id = course_id,
           assignment_category = 'News brief',
           assignment_id = 'News brief 2',
           out_of = 15,
           due_date = '2023-12-04', # arbitrary
           share = TRUE,
           extra_credit = FALSE,
           rubric = news_rubric)


# Wellness project =============================================================

(well_rubric <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                     '<b>Depth & nuance of insights & connections</b> re: wellness & the role of nature in it.' = grade_scale1,
                     'Engaging, captivating, and <b>memorable storytelling.</b> This is not an essay!' = grade_scale1,
                     '<b>Writing is concise, exact, & clear.</b> Conceptual flow is intuitive & straightforward.' = grade_scale1,
                     '<b>Writing is polished and error-free.</b>' = grade_scale3,
                     '<b>Adherence to instructions.</b>' = grade_scale3))

assignment(course_id = course_id,
           assignment_category = 'Wellness Project',
           assignment_id = 'Wellness report',
           out_of = 15,
           due_date = '2023-10-20',
           share = TRUE,
           extra_credit = FALSE,
           rubric = well_rubric)


# Footprint project: baseline report  ==========================================

(foot_rubric1 <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                     '<b>Baseline <u>behavior</u> assessment:</b> thoughtfulness, rigor, care, creativity, ingenuity' = grade_scale1,
                     '<b><u>Impact</u> calculations</b> for carbon, water, land use, social: rigor, resourcefulness, ingenuity' = grade_scale1,
                     '<b>Action plan</b> ambition, strategy, & feasibility.' = grade_scale1,
                     'All <b>sources</b> are cited properly using the Scientific Style.' = grade_scale3,
                     '<b>Writing is polished and error-free.</b>' = grade_scale3,
                     '<b>Adherence to instructions.</b>' = grade_scale3))

assignment(course_id = course_id,
           assignment_category = 'Footprint Project',
           assignment_id = 'Baseline',
           out_of = 15,
           due_date = '2023-09-29',
           share = TRUE,
           extra_credit = FALSE,
           rubric = foot_rubric1)

# Footprint project: team talk  ================================================

(foot_rubric2 <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                      'Talk is <b>engaging, info-dense, efficient</b>, carefully designed, and accurate' = grade_scale1,
                      "<b>A strategic synthesis of the most important content:</b> each section is covered, with a proper balance of overview & detail."=grade_scale1,
                      'The talk is clearly <b>well-planned & thoroughly-rehearsed</b>. Notes are used minimally.' = grade_scale1,
                      '<b>Time allocation</b>: the talk is 8 minutes long exactly.' = grade_scale1,
                      '<b>Visual aides</b> are well-prepared, useful, info-rich & professional. The slides are for the audience, not for the speaker!' = grade_scale1,
                      '<b>Equal participation</b> by all team members, in both prep and delivery.' = grade_scale3,
                      '<b>Adherence to instructions.</b>' = grade_scale3))

assignment(course_id = course_id,
           assignment_category = 'Footprint Project',
           assignment_id = 'Presentation',
           out_of = 15,
           due_date = '2023-12-06',
           share = TRUE,
           extra_credit = FALSE,
           rubric = foot_rubric2)

# Footprint project: final report  =============================================

(foot_rubric3 <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                      '<b>Thoughtfulness, rigor, care, creativity, ingenuity, resourcefulness</b>' = grade_scale1,
                      '<b>Action plan retrospective</b>: plan was followed closely and setbacks were anticipated & handled deftly.' = grade_scale1,
                      'All <b>sources</b> are cited properly using the Scientific Style.' = grade_scale3,
                      '<b>Writing is polished and error-free.</b>' = grade_scale3,
                      '<b>Adherence to instructions.</b>' = grade_scale3))

assignment(course_id = course_id,
           assignment_category = 'Footprint Project',
           assignment_id = 'Final report',
           out_of = 15,
           due_date = '2023-11-29',
           share = TRUE,
           extra_credit = FALSE,
           rubric = foot_rubric3)

# Final essay ==================================================================

(final_rubric <- list('<b>Making meaning, earnest effort, challenging yourself</b>' = grade_scale1,
                      '<b>Profound, informed, nuanced, and courageous engagement</b> with the semester of material.' = grade_scale1,
                     '<b>Clear, coherent, & compelling organization,</b> guided by a single central idea/thesis.' = grade_scale1,
                     '<b>All supporting content is presented well & clearly.</b> Reason is balanced with stories of the human heart.' = grade_scale1,
                     '<b>Concepts are explained well & clearly,</b> with attention to word-choice and order of ideas.' = grade_scale1,
                     '<b>Writing is concise, exact, & clear.</b> Conceptual flow is intuitive & straightforward.' = grade_scale1,
                     '<b>Writing is polished and error-free.</b>' = grade_scale3,
                     '<b>Adherence to instructions.</b>' = grade_scale3))

assignment(course_id = course_id,
           assignment_category = 'Final essay',
           assignment_id = 'Final essay',
           out_of = 20,
           due_date = '2023-12-12',
           share = TRUE,
           extra_credit = FALSE,
           rubric = final_rubric)


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
view_assignments('ENST_101') # View simple list of assignments
view_status('ENST_101') # get a master list of all assignments on file and the grades that are already complete.
view_missing('ENST_101') # are any students without a grade for an assignment that was already due?
render_grades('ENST_101') # Re-render grade reports in a batch, if needed (helpful it modifying the ggplot code)

# Share grades =================================================================

view_unshared('ENST_101') # Return which grades have not yet been shared

email_grades(course_id = 'ENST_101',
             unshared_only = TRUE,
             your_email = 'ekezell@sewanee.edu',
             json_path = '/Users/erickeen/repos/credentials/desktop_gradebook.json')


# Reports ======================================================================

render_student('ENST_101',
               'Student 1')

render_class('ENST_101')












