require 'rails_helper'
require 'general_helpers'

describe Lesson, type: :model do
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

  let!(:question_16){create_question_with_order(16,"c1")}
  let!(:answer_16){create_answer(question_16,16)}
  let!(:question_15){create_question_with_order(15,"e1")}
  let!(:answer_15){create_answer(question_15,15)}
  let!(:question_12){create_question_with_order(12,"z1")}
  let!(:answer_12){create_answer(question_12,12)}
  let!(:question_11){create_question_with_order(11,"d1")}
  let!(:answer_11){create_answer(question_11,11)}
  let!(:question_14){create_question_with_order(14,"d1")}
  let!(:answer_14){create_answer(question_14,14)}
  let!(:question_13){create_question_with_order(13,"b1")}
  let!(:answer_13){create_answer(question_13,13)}

  let!(:question_21){create_question_with_order(21,"c1")}
  let!(:answer_21){create_answer(question_21,21)}
  let!(:question_22){create_question_with_order(22,"e1")}
  let!(:answer_22){create_answer(question_22,22)}
  let!(:question_23){create_question_with_order(23,"e1")}
  let!(:answer_23){create_answer(question_23,23)}
  let!(:question_24){create_question_with_order(24,"d1")}
  let!(:answer_24){create_answer(question_24,24)}
  let!(:question_25){create_question_with_order(25,"b1")}
  let!(:answer_25){create_answer(question_25,25)}
  let!(:question_26){create_question_with_order(26,"z1")}
  let!(:answer_26){create_answer(question_26,26)}


  describe '#question_orders' do
    it 'returns an array of ordered question orders' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.question_orders).to eq ["b1", "c1", "d1", "e1", "z1"]
    end
  end

  describe '#question_by_order' do
    it 'returns an array of 1 questions of the same order' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.questions_by_order("e1")).to eq [question_15].sort
    end

    it 'returns an array of 2 questions of the same order' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.questions_by_order("d1")).to eq [question_11,question_14].sort
    end
  end

  describe '#next_question_order' do
    it 'returns the first order if no question has been answered' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      expect(lesson.next_question_order(student)).to eq "b1"
    end

    it 'returns the order of the next question based on last answered question 1' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "e1"
    end

    it 'returns the order of the next question based on last answered question 2' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "z1"
    end

    it 'returns the order of the next question based on last answered question 3' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "b1"
    end

    it 'returns the order of the next question based on last answered question 4' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "d1"
    end

    it 'returns the order of the next question based on last answered question 5' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "b1"
    end

    it 'returns the order of the next question based on last answered question 6' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      expect(lesson.next_question_order(student)).to eq "c1"
    end
  end

  describe '#get_next_question_of' do
    it 'returns the next question of a given order at random 1' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      expect(lesson.get_next_question_of("d1",student)).to eq question_14
    end

    it 'returns the next question of a given order at random 2' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      expect(lesson.get_next_question_of("z1",student)).to eq nil
    end

    it 'returns the next question of a given order at random 3' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      srand(100)
      expect(lesson.get_next_question_of("d1",student)).to eq question_11
      srand(101)
      expect(lesson.get_next_question_of("d1",student)).to eq question_14
    end
  end

  describe '#random_question' do
    it 'random pick a question from next order 1' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      expect(lesson.random_question(student)).to eq question_15
    end

    it 'random pick a question from next order 2' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      srand(100)
      expect(lesson.random_question(student)).to eq question_11
      srand(101)
      expect(lesson.random_question(student)).to eq question_14
    end

    it 'random pick a question from next order 3' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      expect(lesson.random_question(student)).to eq question_21
    end

    it 'random pick a question from next order 4' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      srand(100)
      expect(lesson.random_question(student)).to eq question_22
      srand(101)
      expect(lesson.random_question(student)).to eq question_23
    end

    it 'returns nil when all questions has been answered' do
      lesson.questions = [question_16,question_15,question_14,question_13,
        question_12,question_11,question_21,question_22,question_23,question_24,
        question_25,question_26]
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id:question_12.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_16.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_15.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_13.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_11.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_14.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_21.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_22.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_23.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_24.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_25.id, lesson_id:lesson.id, correct: false)
      AnsweredQuestion.create(user_id:student.id, question_id:question_26.id, lesson_id:lesson.id, correct: false)
      expect(lesson.random_question(student)).to eq nil
    end
  end
end
