# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: 'show'

  include Voted

  before_action :set_answer, only: %i[edit update destroy choose_best show]
  before_action :set_question, only: %i[create]

  after_action :publish_answer, only: :create

  def create
    authorize! :create, Answer
    @answer = current_user.answers.new(answer_params.merge(question: @question))
    @comment = Comment.new

    if @answer.save
      flash.now[:notice] = 'Your answer was successfully created.'
    else
      flash.now[:alert] = 'Your answer was not created.'
    end
  end

  def update
    authorize! :update, @answer
    @question = @answer.question
    if @answer.update(answer_params)
      flash.now[:notice] = 'Your answer was successfully updated.'
    else
      flash.now[:alert] = 'Your answer was not updated.'
    end
  end

  def destroy
    authorize! :delete, @answer
    @answer.destroy
    flash.now[:notice] = 'Your answer was successfully deleted.'
  end

  def choose_best
    authorize! :make_the_best, @answer.question
    @answer.make_best
    flash.now[:notice] = 'Your answer was successfully chosen as the best'
    render 'answers/choose_best'
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "#{@question.id}/answers",
      answer: @answer.body,
      user_id: current_user.id
    )
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, files: [], links_attributes: %i[name url])
  end
end
