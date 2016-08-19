class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_and_belongs_to_many :questions,
        -> { extending WithUserAssociationExtension }

  def random
    offset = rand(questions.count)
    questions.offset(offset).first
  end

end
