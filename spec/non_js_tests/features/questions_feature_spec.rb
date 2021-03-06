require 'rails_helper'
require 'general_helpers'

feature 'questions' do
  let!(:course) { create_course  }
  let!(:unit)   { create_unit course }
  let!(:topic)  { create_topic unit }
  let!(:lesson) { create_lesson topic }
  let!(:admin)  { create_admin   }
  let!(:student){ create_student }
  let!(:question_1){create_question(1)}
  let!(:choice_1){create_choice(question_1,1,false)}
  let!(:choice_2){create_choice(question_1,2,true)}
  let!(:question_2){create_question(2)}
  let!(:choice_3){create_choice(question_2,3,false)}
  let!(:choice_4){create_choice(question_2,4,true)}
  let!(:question_3){create_question(3)}
  let!(:choice_5){create_choice(question_3,5,false)}
  let!(:choice_6){create_choice(question_3,6,true)}

  let!(:question_4){create_question(4)}
  let!(:answer_1){create_answer(question_4,1)}
  let!(:answer_2){create_answer(question_4,2)}
  let!(:question_5){create_question(5)}
  let!(:answer_3){create_answer(question_5,3)}

  let!(:question_16){create_question_with_order(16,"c1")}
  let!(:answer_16){create_answer(question_16,16)}
  let!(:question_15){create_question_with_order(15,"c1")}
  let!(:answer_15){create_answer(question_15,15)}
  let!(:question_12){create_question_with_order(12,"d1")}
  let!(:answer_12){create_answer(question_12,12)}
  let!(:question_11){create_question_with_order(11,"d1")}
  let!(:answer_11){create_answer(question_11,11)}
  let!(:question_14){create_question_with_order(14,"b1")}
  let!(:answer_14){create_answer(question_14,14)}
  let!(:question_13){create_question_with_order(13,"b1")}
  let!(:answer_13){create_answer(question_13,13)}

  let!(:question_21){create_question_with_order(21,"a1")}
  let!(:answer_21){create_answer_with_two_values(question_21,21,1.33322,2)}
  let!(:question_22){create_question_with_order(22,"b1")}
  let!(:answer_22){create_answer_with_two_values(question_22,22,-1.23,-2)}

  let!(:question_23){create_question_with_order(23,"b1")}
  let!(:answer_23){create_answers(question_23,[['x=','+5,-8'],['y=','6'],
    ['z=','7'],['w=','8']])}
  let!(:question_24){create_question_with_order(24,"b1")}
  let!(:answer_24){create_answers(question_24,[['a=','+5,-8'],['b=','6'],
    ['c=','7']])}
  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answers(question_25,[['a=','+5,-8,7.1,6.21']])}
  let!(:question_26){create_question_with_order(26,"b1")}
  let!(:answer_26){create_answers(question_26,[['a=','+5,-8,6.21'],['b=','7'],['c=','4']])}

  context 'answering questions partially correct for submission question' do
    scenario 'two out of three correct' do
      lesson.questions = [question_23]
      lesson.save
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson.id, exp: 0, streak_mtp: 1.5)
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 23"
      fill_in "x=", with: '+5,-8'
      fill_in "y=", with: '6'
      fill_in "z=", with: '7'
      fill_in "w=", with: '9'
      click_button 'Submit Answers'
      visit "/units/#{ unit.id }"
      answer_hash = {}
      answer_hash['x='] = "+5,-8"
      answer_hash['y='] = "6"
      answer_hash['z='] = "7"
      answer_hash['w='] = "9"
      expect(AnsweredQuestion.last.answer).to eq answer_hash
      expect(AnsweredQuestion.last.question_id).to eq question_23.id
      expect(page).to have_content '112/1000'
      expect(StudentLessonExp.last.streak_mtp).to eq 1.375
    end

    scenario 'getting all correct' do
      lesson.questions = [question_24]
      lesson.save
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson.id, exp: 0, streak_mtp: 1.2)
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 24"
      fill_in "a=", with: '+5,-8'
      fill_in "b=", with: '6'
      fill_in "c=", with: '7'
      click_button 'Submit Answers'
      visit "/units/#{ unit.id }"
      expect(page).to have_content '120/1000'
    end

    scenario 'getting partially partially correct eg 1' do
      lesson.questions = [question_24]
      lesson.save
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson.id, exp: 0, streak_mtp: 2)
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 24"
      fill_in "a=", with: '5,-6'
      fill_in "b=", with: '9'
      fill_in "c=", with: '10'
      click_button 'Submit Answers'
      visit "/units/#{ unit.id }"
      expect(StudentLessonExp.last.streak_mtp).to eq 1.16666666666667
      expect(page).to have_content '33/1000'
    end

    scenario 'getting partially partially correct eg 2' do
      lesson.questions = [question_25]
      lesson.save
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson.id, exp: 0, streak_mtp: 2)
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 25"
      fill_in "a=", with: '6.211'
      click_button 'Submit Answers'
      visit "/units/#{ unit.id }"
      expect(StudentLessonExp.last.streak_mtp).to eq 1.25
      expect(page).to have_content '50/1000'
    end

    scenario 'getting partially partially correct eg 3' do
      lesson.questions = [question_26]
      lesson.save
      StudentLessonExp.create(user_id: student.id, lesson_id: lesson.id, exp: 0, streak_mtp: 2)
      sign_in student
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 26"
      fill_in "a=", with: '6.211,-8'
      fill_in "b=", with: 'wrong'
      click_button 'Submit Answers'
      visit "/units/#{ unit.id }"
      expect(StudentLessonExp.last.streak_mtp).to eq 1.22222222222222
      expect(page).to have_content '44/1000'
    end
  end

  context 'answering a question with submission of multiple answers' do
    scenario 'entering correct answer of two x values' do
      lesson.questions = [question_21]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      fill_in "x21", with: '2.0,1.333'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_21.id).first
      expect(answered_question.correct).to eq true
    end

    scenario 'entering correct answer of two x values' do
      lesson.questions = [question_21]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      fill_in "x21", with: '2.1,1.333'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_21.id).first
      expect(answered_question.correct).to eq false
    end

    scenario 'entering correct answer of two negative x values' do
      lesson.questions = [question_22]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      fill_in "x22", with: '-2,-1.23'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_22.id).first
      expect(answered_question.correct).to eq true
    end

    scenario 'entering correct answer of two negative x values' do
      lesson.questions = [question_22]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      fill_in "x22", with: '-1.231,asdf -2'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_22.id).first
      expect(answered_question.correct).to eq true
    end
  end

  context 'questions are orderedly randomly choosen' do
    scenario 'first question is an ordered a1 question' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      sign_in student
      visit "/units/#{ unit.id }"
      if page.has_content?("question text 13")
        fill_in 'x13', with: '1313'
      end
      if page.has_content?("question text 14")
        fill_in 'x14', with: '1414'
      end
      click_button 'Submit Answers'
      visit "/units/#{ unit.id }"
      expect(page).to have_content "Exp: 100 / 1000 Lvl 1"
      expect(page).to have_content "100/1000 Pass"
    end
  end

  context 'checking answers to none-multiple choice questions' do
    scenario 'entering correct answer' do
      lesson.questions = [question_4,question_5]
      lesson.save
      sign_in student
      srand(101)
      # srand(102)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 5"
      fill_in "x3", with: '33'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_5.id).first
      expect(answered_question.correct).to eq true
    end

    scenario 'entering wrong answer' do
      lesson.questions = [question_4,question_5]
      lesson.save
      sign_in student
      srand(101)
      # srand(102)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 5"
      fill_in "x3", with: '123,457'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_5.id).first
      expect(answered_question.correct).to eq false
    end

    scenario 'entering correct answers for question with two answers' do
      lesson.questions = [question_4,question_5]
      lesson.save
      sign_in student
      srand(102)
      # srand(103)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 4"
      expect(page).to have_content "answer hint 1"
      fill_in "x1", with: '11'
      fill_in "x2", with: '22'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_4.id).first
      expect(answered_question.correct).to eq true
    end

    scenario 'entering one wrong answer for question with two answers' do
      lesson.questions = [question_4,question_5]
      lesson.save
      sign_in student
      srand(102)
      # srand(103)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 4"
      expect(page).to have_content "answer hint 1"
      fill_in "x1", with: '11'
      fill_in "x2", with: 'wrong'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_4.id).first
      expect(answered_question.correct).to eq false
    end

    scenario 'leaving one answer blank for question with two answers' do
      lesson.questions = [question_4,question_5]
      lesson.save
      sign_in student
      srand(102)
      # srand(103)
      visit "/units/#{ unit.id }"
      expect(page).to have_content "question text 4"
      expect(page).to have_content "answer hint 1"
      fill_in "x1", with: '11'
      click_button 'Submit Answers'
      answered_question = AnsweredQuestion.where(user_id:student.id,
        question_id:question_4.id).first
      expect(answered_question.correct).to eq false
    end
  end

  context 'viewing list of all questions' do
    scenario 'when signed in as admin display a list of questions' do
      sign_in admin
      visit '/'
      click_link 'Questions'
      fill_in "Lesson ID", with: 'all'
      click_button 'Filter by this Lesson ID'
      expect(page).to have_content "question text 1"
      expect(page).to have_content "question text 2"
      expect(page).to have_content "solution 1"
      expect(page).to have_content "solution 2"
    end

    scenario 'when not signed, cannot see questions' do
      visit '/'
      expect(page).not_to have_link "Questions"
      visit '/questions'
      expect(page).not_to have_content "question text 1"
      expect(page).not_to have_content "question text 2"
      expect(page).not_to have_content "solution 1"
      expect(page).not_to have_content "solution 2"
    end

    scenario 'when signed in as a student, cannot see questions' do
      sign_in student
      visit '/'
      expect(page).not_to have_link "Questions"
      visit '/questions'
      expect(page).not_to have_content "question text 1"
      expect(page).not_to have_content "question text 2"
      expect(page).not_to have_content "solution 1"
      expect(page).not_to have_content "solution 2"
    end
  end

  context 'adding questions' do
    context 'from questions page' do
      before(:each) do
        sign_in admin
        visit "/questions"
        first(:link, 'Add a question').click
      end

      scenario 'an admin adding a question' do
        fill_in 'Question text', with: 'Solve $2+x=5$'
        fill_in 'Solution', with: '$x=2$'
        fill_in 'Difficulty level', with: 2
        fill_in 'Experience', with: 100
        click_button 'Create Question'
        expect(page).to have_content 'Solve $2+x=5$'
        expect(page).to have_content '$x=2$'
        expect(current_path).to eq "/questions/new"
      end

      scenario 'an admin adding question with image' do
        fill_in 'Question text', with: 'Solve $2+x=5$'
        fill_in 'Solution', with: '$x=2$'
        fill_in 'Difficulty level', with: 2
        fill_in 'Experience', with: 100
        attach_file 'Question image', Rails.root + "spec/fixtures/image_1.png"
        click_button 'Create Question'
        expect(page).to have_content 'Solve $2+x=5$'
        expect(page).to have_content '$x=2$'
        expect(page).to have_css("#image-#{last_question.id}-1")
      end

    end

    scenario 'an admin adding a question from add question page via tex file upload' do
      sign_in admin
      visit "/questions/new"
      attach_file("Tex File", tex_upload_file)
      click_button "Create questions from Tex"
      expect(current_path).to eq "/questions/new"
      expect(page).to have_content "Questions have been saved successfully from the file"
    end

    scenario 'cannot add a question when not logged in as admin' do
      visit '/questions'
      expect(page).not_to have_link 'Add a question'
      expect(current_path).to eq new_user_session_path
    end

    scenario 'cannot add a question when logged in as student' do
      sign_in student
      visit '/questions'
      expect(page).not_to have_link 'Add a question'
      expect(page).to have_content 'Good try but no - you cannot see the questions and solutions list!...:)'
      visit '/questions/new'
      expect(page).to have_content 'You do not have permission to create a question'
    end
  end

  context 'updating questions' do
    xscenario 'an admin can update questions' do
      sign_in admin
      visit "/questions"
      click_link("edit-question-#{question_1.id}")
      fill_in 'Question text', with: 'New question'
      fill_in 'Solution', with: 'New solution'
      click_button 'Update Question'
      expect(page).to have_content 'New question'
      expect(page).to have_content 'New solution'
      expect(page).to have_content "question text 2"
      expect(page).to have_content "solution 2"
      expect(current_path).to eq "/questions/new"
    end

    scenario 'an admin adds another image to question' do
      sign_in admin
      visit "/questions"
      fill_in "Lesson ID", with: "all"
      click_button 'Filter by this Lesson ID'
      click_link("edit-question-#{question_1.id}")
      attach_file 'Question image', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Update Question'
      expect(page).to have_css("#image-#{question_1.id}-1")
      click_link("edit-question-#{question_1.id}")
      attach_file 'Question image', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Update Question'
      expect(page).to have_css("#image-#{question_1.id}-2")
    end

    scenario "when not signed in cannot edit questions" do
      visit "/questions"
      expect(page).not_to have_link "Edit question"
      visit "/questions/#{question_1.id}/edit"
      expect(current_path).to eq new_user_session_path
    end

    scenario "a student cannot edit questions" do
      sign_in student
      visit "/questions"
      expect(page).not_to have_link "Edit question"
      visit "/questions/#{question_1.id}/edit"
      expect(page).to have_content 'You do not have permission to edit a question'
      expect(current_path).to eq "/"
    end
  end

  context 'deleting questions' do
    scenario 'an admin can delete their own questions' do
      sign_in admin
      visit "/questions"
      fill_in "Lesson ID", with: 'all'
      click_button 'Filter by this Lesson ID'
      click_link("delete-question-#{question_13.id}")
      visit "/questions"
      fill_in "Lesson ID", with: 'all'
      click_button 'Filter by this Lesson ID'
      expect(page).not_to have_content 'question text 13'
      expect(page).not_to have_content 'solution 13'
      expect(current_path).to eq "/questions"
    end

    scenario 'an admin can delete question image' do
      sign_in admin
      visit "/questions"
      fill_in "Lesson ID", with: "all"
      click_button 'Filter by this Lesson ID'
      click_link("edit-question-#{question_1.id}")
      attach_file 'Question image', Rails.root + "spec/fixtures/image_1.png"
      click_button 'Update Question'
      expect(page).to have_css("#image-#{question_1.id}-1")
      click_link("delete-image-#{question_1.id}-1")
      expect(page).not_to have_css("#image-#{question_1.id}-1")
    end

    scenario "when not signed in cannot delete questions" do
      visit "/questions"
      expect(page).not_to have_css "#delete-question-#{question_1.id}"
      page.driver.submit :delete, "/questions/#{question_1.id}",{}
      expect(current_path).to eq new_user_session_path
    end

    scenario "a student cannot delete another maker's questions" do
      sign_in student
      visit "/questions"
      expect(page).not_to have_css "#delete-question-#{question_1.id}"
      page.driver.submit :delete, "/questions/#{question_1.id}",{}
      expect(page).to have_content 'You do not have permission to delete a question'
    end
  end

  context 'filtering lesson questions' do
    scenario 'filtering with a specific order group' do
      lesson.questions = [question_21,question_22]
      lesson.save
      sign_in admin
      visit '/questions'
      fill_in "Lesson ID", with: "#{lesson.id}"
      fill_in "Order Group", with: "a1"
      click_button "Filter by this Lesson ID"
      expect(page).to have_content 'question text 21'
      expect(page).not_to have_content 'question text 22'
    end

    scenario 'filtering without a specific order group' do
      lesson.questions = [question_21,question_22]
      lesson.save
      sign_in admin
      visit '/questions'
      fill_in "Lesson ID", with: "#{lesson.id}"
      click_button "Filter by this Lesson ID"
      expect(page).to have_content 'question text 21'
      expect(page).to have_content 'question text 22'
    end
  end
end
