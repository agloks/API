require "./spec_helper"

def question_hash
  {"content" => "?"}
end

def question_params
  "content=#{question_hash["content"]}"
end

def create_question
  model = Question.new(question_hash)
  model.save
  model
end

class QuestionControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :api do
      plug Amber::Pipe::Error.new
    end
    @handler.prepare_pipelines
  end
end

describe QuestionControllerTest do
  Spec.before_each do
    Media.clear
    Question.clear
  end

  subject = QuestionControllerTest.new
  describe "#create" do
    it "creates a question" do
      media = Media.create(title: "qwekjh")
      response = subject.post "/medias/#{media.id}/questions", body: question_params

      response.status_code.should eq(201)
      json = JSON.parse(response.body)
      (json["content"]).should eq("?")
      (json["media_id"]).should eq(media.id)
    end
  end

  describe "#index" do
    it "shows questions of a media" do
      media = Media.create(title: "qwekjh")
      question1 = Question.create(content: "qwerty", media_id: media.id)
      question2 = Question.create(content: "qwerty")
      response = subject.get "/medias/#{media.id}/questions"

      response.status_code.should eq(200)
      response.body.should contain([question1].to_json)
    end
  end

  describe "#show" do
    it "shows a question" do
      media = Media.create(title: "qwekjh")
      question = Question.create(content: "qwerty", media_id: media.id)
      response = subject.get "/medias/#{media.id}/questions/#{question.id}"

      response.status_code.should eq(200)
      response.body.should contain(question.to_json)
    end
  end

  describe "#update" do
    it "updates a question" do
      media = Media.create(title: "qwekjh")
      question = Question.create(content: "qwerty", media_id: media.id)
      response = subject.put "/medias/#{media.id}/questions/#{question.id}", body: question_params

      response.status_code.should eq(200)
      json = JSON.parse(response.body)
      (json["content"]).should eq("?")
    end
  end

  describe "#delete" do
    it "deletes a question" do
      media = Media.create(title: "qwekjh")
      question = Question.create(content: "qwerty", media_id: media.id)
      response = subject.delete "/medias/#{media.id}/questions/#{question.id}"

      response.status_code.should eq(204)
    end
  end
end
