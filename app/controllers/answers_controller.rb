class AnswersController < ApplicationController
  expose :question, id: -> { params[:question_id] }
  expose :answers, -> { Answer.all }
  expose :answer

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question_answer_path(question, @answer)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_answer_path(question, answer)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to question_path(question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end