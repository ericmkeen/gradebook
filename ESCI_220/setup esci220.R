################################################################################
################################################################################
# ENST 209 setup
################################################################################
################################################################################

# Set course ID
course_id <- 'ESCI_220'

# Students
students_url <- 'https://docs.google.com/spreadsheets/d/1LIcIQssXAkxxoJtCR5A5QAovATB3RbAf3ry2m7gGCIE/edit?usp=sharing'
update_roster('ESCI_220', students_url) # rerun this each time your googlesheet is changed

# Quick view of students
view_students('ESCI_220')

################################################################################
################################################################################
# Assignments
################################################################################
################################################################################

data(grade_scale1) ; grade_scale1
data(grade_scale2) ; grade_scale2
data(grade_scale3) ; grade_scale3

# R workshops ==================================================================

asscat <- 'R workshops'
out_of <- 10
share <- TRUE
(rubric <- list('All answers have been attempted' = grade_scale3,
               'Code is correct & effor-free' = grade_scale3,
               'Code comments are thorough & ubiquitous' = grade_scale3,
               'Plots / visualizations are gorgeous' = grade_scale1,
               'All instructions followed' = grade_scale3))

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'R workshop #1 GHG emissions',
           out_of = out_of,
           due_date = '2023-09-08',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'R workshop #2 The energy mix',
           out_of = out_of,
           due_date = '2023-09-15',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'R workshop #3 Carbon offsets',
           out_of = out_of,
           due_date = '2023-09-29',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'R workshop #4 Mapping injustice',
           out_of = out_of,
           due_date = '2023-10-06',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'R workshop #5 Roadside plastics',
           out_of = out_of,
           due_date = '2023-10-13',
           share = share, rubric = rubric)

# Briefs =======================================================================

asscat <- 'Briefs'
out_of <- 15
share <- TRUE
rubric <- list('Content' = 'category',
               'All content is factually correct.' = grade_scale1,
               'Comprehensive; all sources covered properly.' = grade_scale1,
               'Detailed; dense & efficient info transfer.' = grade_scale1,
               '<u>Every single sentence</u> is supported with a citation.' = grade_scale3,
               'Clear & exact explanations' = grade_scale3,
               'All jargon/acronyms are explained' = grade_scale3,
               'Overall organization is crystal-clear & intuitive' = grade_scale3,
               'Style' = 'category',
               'Organization is emphasized with <b>short paragraps, bolf-face terms, & bold-face topic-sentences / subheadings</b>.' = grade_scale3,
               '<b>Bullet lists</b> (if used) are neat, fitting each item onto <b>a single line</b> whenever possible.' = grade_scale3,
               'Writing is <b>succinct, exact & clear</b>.' = grade_scale1,
               '<b>Writing is polished and error-free.</b>' = grade_scale3,
               '<b>Adherence to instructions.</b>' = grade_scale3,
               'Overall, document is <b>highly polished & professional</b>' = grade_scale1)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'Brief #1',
           out_of = out_of,
           due_date = '2023-09-13',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'Brief #2',
           out_of = out_of,
           due_date = '2023-09-27',
           share = share, rubric = rubric)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'Brief #3',
           out_of = out_of,
           due_date = '2023-10-11',
           share = share, rubric = rubric)


# Team Briefs to the public   ==================================================

rubric <- list('Substance' = 'category',
               '<b>First moments:</b> Excellent, engaging, memorable & relevant attention getter, setting the tone for the entire talk.' = grade_scale1,

               'Early audience orientation: Sound orientation to topic & clear thesis delivered early. Early moments include preview of main points. Credibility firmly established.' = grade_scale1,

               '<b>Compelling justification:</b> The audience is made to care about the issue & context first <b>before any mention</b> of research or method.' = grade_scale1,
               '<b>Story & narrative:</b> organization takes the form of a story, taking the audience on a shared journey. Anecdotes and stories are used throughout' = grade_scale1,
               '<b>Problem statement & proposed project:</b> justification leads to a clear problem statement & proposed project. What you are proposing to do is crystal clear' = grade_scale1,
               '<b>Proposed methods:</b> project plan is presented in an elegant & compelling way, leaving no doubt that this project is feasible, legitimate, and worthwhile' = grade_scale1,
               '<b>Pre- & Misconceptions:</b> anticipation of preconceptions regarding topic & presenter, addressed & moved beyond deftly. No elephants in room go unmentioned' = grade_scale1,
               '<b>Broader impacts</b>, relevance & importance: compelling case for the importance of topic to the audience’s lives, appealing to heart & gut (empathy)' = grade_scale1,
               '<b>Call to action:</b> justification leads to a clear “call to action”, asking the audience to join you in a cause.' = grade_scale1,
               '<b>Final moments:</b> clear & memorable summary of points; refers back to thesis/proposed project. Ends with strong take-away/punchline that “seals the deal”.' = grade_scale1,
               '<b>Organization overall:</b> audience is given transitions, signposts & reminders that allow them to readily reconstruct the case being made.' = grade_scale1,
               'Delivery' = 'category',
               '<b>Preparation:</b> clearly well-prepared, evident in the timing of the talk, familiarity with visual aids and what will be said, & little/no reliance upon notes.' = grade_scale1,
               '<b>Time allocation:</b> delivered within the allocated time window; time within the talk is allocated strategically. ' = grade_scale1,
               '<b>Speech:</b> conversational, sincere, dynamic & compelling; pace of speech is easily followed; no trailing off or rambling; no vocal fillers; impactful use of pauses.' = grade_scale1,
               '<b>Language:</b> can articulate meaning clearly through eloquent word choice & premeditated sentences; no unexplained jargon, abbreviations or acronyms.' = grade_scale1,
               '<b>Explanation:</b> Any word/concept that may not be understood is explained, either explicitly or within abundant context, at a level appropriate to audience.' = grade_scale1,
               '<b>Non-verbal delivery:</b> The “Second Conversation”: Attire, composure, & body language reflect sincerity & professionalism, without sacrificing authenticity.' = grade_scale1,
               '<b>Mistakes:</b> mistakes are handled in a graceful & self-forgiving manner; recovery is quick.' = grade_scale1,
               '<b>Attentive, responsive, & adaptive:</b> does not presume audience attention, but actively elicits & maintains it, changing course or re-framing something as needed.' = grade_scale1,
               '<b>Energetic, credible, human, relatable, genuine, poised, confident but vulnerable, at ease</b>' = grade_scale1,
               '<b>Inclusive & welcoming:</b> creates common ground by strongly emphasizing common values/experiences.' = grade_scale1,
               'Visual aids' = 'category',
               '<b>Strategic use:<b/> redundancy (if any) between what is spoken and what is displayed is strategic, not used as a crutch for presenting.' = grade_scale1,
               '<b>Design & display:</b> of professional quality, not sloppy or thrown together. Aids prioritize simplicity, clarity, and good design.' = grade_scale1,
               '<b>Visualizing info:</b> Use of text is minimal & appropriately sized. Any data visualization has been reduced to the simplest possible form.' = grade_scale1
)


assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'Team Brief to the Public',
           out_of = 5,
           due_date = '2023-09-01',
           share = TRUE,
           rubric = rubric)


# Mini-Watson: pre-proposal  ===================================================

asscat <- 'Mini-Watson'
rubric <- list('Content' = 'category',
               'Project track identified' = grade_scale3,
               'Includes all details needed to understand the basic project idea.' = grade_scale3,
               'Justification of personal significance' = grade_scale3,
               'Justification of intended impacts & benefits' = grade_scale3,
               'Style' = 'category',
               'Writing is <b>succinct, exact & clear</b>.' = grade_scale3,
               '<b>Writing is polished and error-free.</b>' = grade_scale3,
               '<b>Adherence to instructions.</b>' = grade_scale3,
               'Overall, document is <b>polished & presented professionally</b>' = grade_scale3)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'Mini-Watson Pre-proposal',
           out_of = 15,
           due_date = '2023-09-01',
           share = TRUE,
           rubric = rubric)

# Mini-Watson: Full proposal  ==================================================

rubric <- list('Personal statement' = 'category',
               'Compelling & powerful portrayal of your story, your values, & what drives you.' = grade_scale1,
               'Convincing justification of project fit with who you are. This project was made for you.' = grade_scale1,
               'Project proposal' = 'category',
               'A moving case for why others should care about this project too.' = grade_scale1,
               'The project is multi-dimensional and endlessly fascinating.' = grade_scale1,
               'Little to no redundancy between personal statement and project proposal.' = grade_scale1,
               'The whole proposal is shining with personal meaning & deep resolve to make this happen.' = grade_scale1,
               'Writing' = 'category',
               'Overall: engaging, compelling, and evocative' = grade_scale1,
               'A story or a vulnerable conversation, not an essay!' = grade_scale1,
               'Overall organization is intuitive & cyrstal-clear.' = grade_scale1,
               'Writing is succinct, exact & clear.' = grade_scale3,
               'Writing is polished and error-free.' = grade_scale3,
               'Adherence to instructions.' = grade_scale3,
               'Overall, document is polished & presented professionally.' = grade_scale3)

assignment(course_id = course_id, assignment_category = asscat,
           assignment_id = 'Mini-Watson full proposal',
           out_of = 15,
           due_date = '2023-09-25',
           share = TRUE,
           rubric = rubric)

# RGP: Pre-proposal draft ======================================================

asscat <- 'Research Grant Proposal'

rubric <- list('Content' = 'category',
               'Identification of project category' = grade_scale3,
               'Working title' = grade_scale3,
               'Description of what exactly the project will focus on / involve' = grade_scale3,
               'Articulation of the knowledge gap / need that this project will address' = grade_scale3,
               'Explanation of how your project will contribute to addressing the aforementioned need/knowledge gap' = grade_scale3,
               'Personal justification of project choice / making meaning' = grade_scale3,
               'Articulation of how project will challenge student' = grade_scale3,
               'Career justification of project choice' = grade_scale3,
               'Project is ambitious, given the previous experience of the student.' = grade_scale3,
               'Project is feasible, given time- and resource-constraints.' = grade_scale3,
               'Writing' = 'category',
               'Writing is <b>succinct, exact & clear</b>.' = grade_scale3,
               '<b>Writing is polished and error-free.</b>' = grade_scale3,
               '<b>Adherence to instructions.</b>' = grade_scale3,
               'Overall, document is <b>polished & presented professionally</b>' = grade_scale3)

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Pre-proposal draft',
           out_of = 10,
           due_date = '2023-10-18',
           share = TRUE,
           rubric = rubric)

# RGP: Pre-proposal  ===========================================================

# use same rubric as above
assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Pre-proposal submission',
           out_of = 10,
           due_date = '2023-10-20',
           share = TRUE,
           rubric = rubric)

# RGP: Literature review =======================================================

rubric <- list('Provided in the instructed format (one source on each page, full citation at the top of each page, followed by notes)' = grade_scale3,
               'Scientific Style is used for full citations at top of page' = grade_scale3,
               'At least 20 sources are included in your review.' = grade_scale1,
               'These sources include the earliest foundational works in the field.' = grade_scale3,
               'These sources include the most recent advances in the field.' = grade_scale3,
               'Notes on each source indicate earnest & strategic effort has gone into work' = grade_scale3,
               'The main contribution(s) of the source is noted clearly' = grade_scale3,
               'Direct quotes are wrapped in quotation marks' = grade_scale3,
               'Each source is mined for other potential sources' = grade_scale3,
               'All formatting instructions followed ' = grade_scale3,
               'Overall, highly polished & professionally presented' = grade_scale3)

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Literature Review',
           out_of = 10,
           due_date = '2023-10-30',
           share = TRUE,
           rubric = rubric)

# RGP: Intro outline ===========================================================

rubric <- list('First page is a Paragraph Breakdown, with a purpose statement for every paragraph in the Intro' = grade_scale3,
               'Each paragraph serves a single purpose only' = grade_scale3,
               'Each subsequent page provides a collection of source notes for each paragraph, with the purpose statement in bold at the top.' = grade_scale3,
               'Every single source note has a parenthetical reference to the source.' = grade_scale3,
               'Each paragraph has plenty of associated notes, and all sources in the Lit Review have been referenced.' = grade_scale3,
               '<b>Engage & justify:</b> amounts to a carefully planned, convincing argument for the importance & urgency of your project.' = grade_scale1,
               '<b>Establish context & convince readers to care.</b> Early into the outline, place your topic in a broad context.' = grade_scale1,
               'The first paragraph’s purpose is an accessible & engaging starting point of common ground for optimizing reader buy-in for your project.' = grade_scale1,
               'Narrow in on a problem statement (a knowledge gap, an urgent need).' = grade_scale3,
               'Follow with a motivation/objectives statement. Your study is a response to the problem statement.' = grade_scale3,
               'The paragraphs between the first and the problem statement are designed to guide the reader through a persuasive, well-founded argument for your project’s need.' = grade_scale1,
               'Overall the document is highly polished & professionally presented' = grade_scale1)

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Intro Outline',
           out_of = 10,
           due_date = '2023-11-3',
           share = TRUE,
           rubric = rubric)

# RGP: Full introduction =======================================================

rubric <- list('Content' = 'category',
               '<b>Engage & justify:</b> amounts to a carefully planned, convincing argument for the importance & urgency of your project.' = grade_scale1,
               '<b>Establish context & convince readers to care.</b> Early into the outline, place your topic in a broad context.' = grade_scale1,
               '<b>Invite readers in.</b> A good Intro is an accessible one that draws in a wide audience.' = grade_scale1,
               'The first paragraph purpose is an accessible & engaging starting point of common ground for optimizing reader buy-in for your project.' = grade_scale1,
               'Each paragraph serves a single purpose only, and a single purpose statement is clearly obvious therein.' = grade_scale3,
               'Demonstrate exhaustive knowledge of the topic' = grade_scale1,
               'Demonstrate basis in previous research. Aim for a 1:1 ratio of citations to sentences.' = grade_scale1,
               'More than a history lesson / list of facts. Your Introduction is a tightly organized and persuasive argument.' = grade_scale1,
               'Narrow in on a problem statement.' = grade_scale1,
               'Follow immediately with a motivation/objectives statement. Your study is a response to the problem statement.' = grade_scale1,
               'Writing' = 'category' ,
               'Overall, writing is succinct, exact, & clear.' = grade_scale1,
               'First-person is not over-used; when used, it does not draw attention to the author.' = grade_scale3,
               'There are no typos or errors; has clearly been proofread & revised carefully.' = grade_scale3,
               'Sentence-to-sentence flow is intuitive, word-efficient, and easy to follow.' = grade_scale1,
               'Most sentences end on their punchline/take-away, facilitating a clear & purpose-oriented voice' = grade_scale1,
               'Overall the document is highly polished & professionally presented' = grade_scale1 )

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Introduction',
           out_of = 10,
           due_date = '2023-11-10',
           share = TRUE,
           rubric = rubric)

# RGP: Sampling schematic ======================================================

rubric <- list('Schematic is intuitive, organized, easy to read & comprehend.' = grade_scale1,
               'Demonstrates the workflow of your proposed field methods in a way that helps the reader understand what exactly you are planning to do' = grade_scale1,
               'Beautiful, polished, & professional' = grade_scale1)

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Sampling schematic',
           out_of = 10,
           due_date = '2023-11-16',
           share = TRUE,
           rubric = rubric)

# RGP: Dream table & figures ===================================================

rubric <- list('Table(s) is (are) intuitive, organized, easy to read & comprehend.' = grade_scale1,
               'Figure(s) is (are) intuitive, organized, easy to read & comprehend.' = grade_scale1,
               'At least one of your figures provids the punchline of your study, displaying in a single figure the key insight you hope to achieve in this project.' = grade_scale3,
               'All tables & figures are beautiful, polished, & professional' = grade_scale1)

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Dream tables and figures',
           out_of = 10,
           due_date = '2023-11-17',
           share = TRUE,
           rubric = rubric)

# RGP: First full submission ===================================================

rubric <- list('<b>Front matter:</b> title, author, date, word counts for Abstract & main text.' = grade_scale1,
               '<b>Abstract</b> is a concise, sharp & informative distillation of your entire paper, 250 words or less' = grade_scale1 ,
               '<b>Introduction</b> meets all standards detailed in its respective rubric.' = grade_scale1 ,
               'This new version of the Intro represents a significant revision.' = grade_scale3,
               'Methods' = 'category',
               'The <b>study area</b> is described in sufficient detail to understand all possible considerations of study design & results interpretation.' = grade_scale1,
               '<b>Field methods</b> make sense based upon the research question and the objectives stated in your Intro.' = grade_scale1,
               '<b>Analytical approach</b> is sound & appropriate given your objectives and the limitations of your data' = grade_scale1,
               'Field methods are <b>fully reproducible</b> given the level of detail and quality of explanation.' = grade_scale1,
               'Data analysis are fully reproducible.' = grade_scale3,
               '<b>Schematic/diagram</b> of your sampling plan is beautiful and helpful.' = grade_scale1,
               'Analytical approach is properly <b>thorough & focused</b>' = grade_scale1,
               '<b>No unnecessary reinventing of wheels.</b> Established methods in your field have properly adapted & cited.' = grade_scale3,
               'Methods section contains Methods *only* – no material that belongs in other sections' = grade_scale3,
               'Anticipated results' = 'category',
               'A <b>concise narrative</b>, without interpretation or commentary on their importance or consequences.' = grade_scale1,
               'Complete based on the analyses you described in your Methods section.' = grade_scale3,
               'Appropriate, given the limitations of the data and the methods you employed.' = grade_scale3 ,
               '<b>Tables & figures</b> are beautiful, well-presented & referenced correctly (in terms of both format & order) within the text.' = grade_scale1,
               '<b>Captions</b> meet standards outlined in class.' = grade_scale1,
               'Remaining sections' = 'category',
               '<b>Study Limitations</b> demonstrate that you are thinking proactively about potential pitfalls and constraints on how you interpret your results.' = grade_scale1 ,
               '<b>Broader Impacts</b> are discussed knowledgeably and convincingly, amounting to a convincing concluding argument that this is multi-dimensional, high-impact project.' = grade_scale1 ,
               '<b>Project timeline</b> is detailed, feasible, well-conceived, and well-visualized as a Gantt Chart.' = grade_scale1 ,
               '<b>Project budget</b> is detailed, feasible, well-conceived, and well-visualized.' = grade_scale1 ,
               '<b>Literature Cited</b> is properly formatted and complete, without extraneous unused references. At least 20 sources are used.' = grade_scale1 ,
               'Style' = 'category',
               'Overall, writing is succinct, exact, & clear.' = grade_scale1,
               'Sentence-to-sentence flow is intuitive, word-efficient, and easy to follow.' = grade_scale1,
               'First-person is not over-used; when used, it does not draw attention to the author.' = grade_scale3,
               'There are no typos or errors; has clearly been proofread & revised carefully.' = grade_scale3,
               'Most sentences end on their punchline/take-away, facilitating a clear & purpose-oriented voice' = grade_scale1,
               'All formatting instructions followed' = grade_scale3,
               'Overall the document is highly polished & professionally presented' = grade_scale1 )

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Full submission',
           out_of = 10,
           due_date = '2023-12-04',
           share = TRUE,
           rubric = rubric)

# RGP: Peer review =============================================================

rubric <- list('Content' = 'category',
               'Line-by-line comments are detailed, thorough, and constructive.' = grade_scale1,
               'All comments have an associated section/paragraph number.' = grade_scale3,
               'In the intro letter, your overall impressions are specific and constructive, amounting to a very helpful summary of the details below.' = grade_scale1 ,
               'In the intro letter, section summaries are thorough, specific, and constructive.' = grade_scale1 ,
               'Style' = 'category',
               'Overall, writing is succinct, exact, & clear.' = grade_scale1 ,
               'There are no typos or errors; has clearly been proofread & revised carefully' = grade_scale3 ,
               'Overall the document is highly polished & professionally presented' = grade_scale1 )

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Peer review',
           out_of = 10,
           due_date = '2023-12-06',
           share = TRUE,
           rubric = rubric)


# RGP: Response to review ======================================================

rubric <- list('Begin your response with a greeting to your review and thanking them for their thorough and constructive help.' = grade_scale1,
               'Each overall comment from your reviewers intro letter is addressed with a response.' = grade_scale1 ,
               'Ditto for each section-specific comment.' = grade_scale1 ,
               'Every single line-by-line comment from your peer’s review is given a specific explanation of how it was addressed.' = grade_scale1 ,
               'Overall, your responses are all kind, detailed, and thorough' = grade_scale1 ,
               'Include a copy of your manuscript with all changes tracked.' = grade_scale1 ,
               'Overall, writing is succinct, exact, & clear' = grade_scale1 ,
               'There are no typos or errors; has clearly been proofread & revised carefully' = grade_scale3,
               'Overall the document is highly polished & professionally presented' = grade_scale1)

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Response to review',
           out_of = 10,
           due_date = '2023-12-12',
           share = TRUE,
           rubric = rubric)


# RGP: Pitch talk ==============================================================

rubric <- list('Substance' = 'category',
               '<b>First moments:</b> Excellent, engaging, memorable & relevant attention getter, setting the tone for the entire talk.' = grade_scale1,
               '<b>Compelling justification:</b> The audience is made to care about the issue & context first <b>before any mention</b> of research or method.' = grade_scale1,
               '<b>Story & narrative:</b> organization takes the form of a story, taking the audience on a shared journey. Anecdotes and stories are used throughout' = grade_scale1,
               '<b>Problem statement & proposed project:</b> justification leads to a clear problem statement & proposed project. What you are proposing to do is crystal clear' = grade_scale1,
               '<b>Proposed methods:</b> project plan is presented in an elegant & compelling way, leaving no doubt that this project is feasible, legitimate, and worthwhile' = grade_scale1,
               '<b>Pre- & Misconceptions:</b> anticipation of preconceptions regarding topic & presenter, addressed & moved beyond deftly. No elephants in room go unmentioned' = grade_scale1,
               '<b>Broader impacts</b>, relevance & importance: compelling case for the importance of topic to the audience’s lives, appealing to heart & gut (empathy)' = grade_scale1,
               '<b>Final moments:</b> clear & memorable summary of points; refers back to thesis/proposed project. Ends with strong take-away/punchline that “seals the deal”.' = grade_scale1,
               '<b>Organization overall:</b> audience is given transitions, signposts & reminders that allow them to readily reconstruct the case being made.' = grade_scale1,
               'Delivery' = 'category',
               '<b>Preparation:</b> clearly well-prepared, evident in the timing of the talk, familiarity with visual aids and what will be said, & little/no reliance upon notes.' = grade_scale1,
               '<b>Time allocation:</b> delivered within the allocated time window; time within the talk is allocated strategically. ' = grade_scale1,
               '<b>Speech:</b> conversational, sincere, dynamic & compelling; pace of speech is easily followed; no trailing off or rambling; no vocal fillers; impactful use of pauses.' = grade_scale1,
               '<b>Language:</b> can articulate meaning clearly through eloquent word choice & premeditated sentences; no unexplained jargon, abbreviations or acronyms.' = grade_scale1,
               '<b>Explanation:</b> Any word/concept that may not be understood is explained, either explicitly or within abundant context, at a level appropriate to audience.' = grade_scale1,
               '<b>Non-verbal delivery:</b> The “Second Conversation”: Attire, composure, & body language reflect sincerity & professionalism, without sacrificing authenticity.' = grade_scale1,
               '<b>Mistakes:</b> mistakes are handled in a graceful & self-forgiving manner; recovery is quick.' = grade_scale1,
               '<b>Attentive, responsive, & adaptive:</b> does not presume audience attention, but actively elicits & maintains it, changing course or re-framing something as needed.' = grade_scale1,
               '<b>Energetic, credible, human, relatable, genuine, poised, confident but vulnerable, at ease</b>' = grade_scale1,
               '<b>Inclusive & welcoming:</b> creates common ground by strongly emphasizing common values/experiences.' = grade_scale1,
               'Visual aids' = 'category',
               '<b>Strategic use:<b/> redundancy (if any) between what is spoken and what is displayed is strategic, not used as a crutch for presenting.' = grade_scale1,
               '<b>Design & display:</b> of professional quality, not sloppy or thrown together. Aids prioritize simplicity, clarity, and good design.' = grade_scale1,
               '<b>Visualizing info:</b> Use of text is minimal & appropriately sized. Any data visualization has been reduced to the simplest possible form.' = grade_scale1
               )

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Pitch talk',
           out_of = 10,
           due_date = '2023-12-10',
           share = TRUE,
           rubric = rubric)


# RGP: Revised final submission ================================================

rubric <- list('Front matter' = 'category',
               'FM: Improvement upon first submission.' = grade_scale3,
               'FM: Overall quality.' = grade_scale1,
               'Introduction' = 'category',
               'I: Improvement upon first submission.' = grade_scale3,
               'I: Overall quality.' = grade_scale1,
               'Methods' = 'category',
               'M: Improvement upon first submission.' = grade_scale3,
               'M: Overall quality.' = grade_scale1,
               'Anticipated results' = 'category',
               'AR: Improvement upon first submission.' = grade_scale3,
               'AR: Overall quality.' = grade_scale1,
               'Study limitations' = 'category',
               'SL: Improvement upon first submission.' = grade_scale3,
               'SL: Overall quality.' = grade_scale1,
               'Broader impacts' = 'category',
               'BI: Improvement upon first submission.' = grade_scale3,
               'BI: Overall quality.' = grade_scale1,
               'Sampling schematic' = 'category',
               'SS: Improvement upon first submission.' = grade_scale3,
               'SS: Overall quality.' = grade_scale1,
               'Tables & figures' = 'category',
               'TF: Improvement upon first submission.' = grade_scale3,
               'TF: Overall quality.' = grade_scale1,
               'Project timeline' = 'category',
               'PT: Improvement upon first submission.' = grade_scale3,
               'PT: Overall quality.' = grade_scale1,
               'Project budget' = 'category',
               'PB: Improvement upon first submission.' = grade_scale3,
               'PB: Overall quality.' = grade_scale1,
               'Overall writing' = 'category',
               'OW: Improvement upon first submission.' = grade_scale3,
               'OW: Overall quality.' = grade_scale1)

assignment(course_id = course_id,
           assignment_category = asscat,
           assignment_id = 'Revised final submission',
           out_of = 10,
           due_date = '2023-12-15',
           share = TRUE,
           rubric = rubric)

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
view_assignments('ESCI_220') # View simple list of assignments
view_status('ESCI_220') # get a master list of all assignments on file and the grades that are already complete.
view_missing('ESCI_220') # are any students without a grade for an assignment that was already due?
render_grades('ESCI_220') # Re-render grade reports in a batch, if needed (helpful it modifying the ggplot code)

# Share grades =================================================================

view_unshared('ESCI_220') # Return which grades have not yet been shared

email_grades(course_id = 'ESCI_220',
             unshared_only = TRUE,
             your_email = 'ekezell@sewanee.edu',
             json_path = '/Users/erickeen/repos/credentials/desktop_gradebook.json')


# Reports ======================================================================

render_student('ESCI_220',
               'Student 2')

render_class('ESCI_220')












