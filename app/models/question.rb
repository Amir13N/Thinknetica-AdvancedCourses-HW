# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :body, :title, presence: true
  validates :body, uniqueness: { scope: :title }

  def best_answer
    answers.find_by(best: true)
  end
end
