class QuestionController < ApplicationController
  getter question = Question.new

  before_action do
    only [:show, :update, :destroy] { set_question }
  end

  def index
    questions = Question.where(media_id: params["media_id"]).select
    respond_with do
      json questions.to_json
    end
  end

  def show
    respond_with do
      json question.to_json
    end
  end

  def create
    question = Question.new creation_question_params.validate!
    if question.save
      respond_with(201) do
        json question.to_json
      end
    else
      respond_with(403) do
        json({errors: formatted_errors(question)}.to_json)
      end
    end
  end

  def update
    question.set_attributes update_question_params.validate!
    if question.save
      respond_with do
        json question.to_json
      end
    else
      respond_with(403) do
        json({errors: formatted_errors(question)}.to_json)
      end
    end
  end

  def destroy
    question.destroy
    respond_with(204) do
      json ""
    end
  end

  private def creation_question_params
    params.validation do
      required :content
      required :media_id
      required :answers
    end
  end

  private def update_question_params
    params.validation do
      optional :content
      optional :answers
    end
  end

  private def set_question
    @question = Question.find! params[:id]
  end
end
