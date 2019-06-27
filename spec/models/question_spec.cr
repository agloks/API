require "./spec_helper"
require "../../src/models/question.cr"

describe Question do
  Spec.before_each do
    Question.clear
  end

  describe "relations" do
    it "belongs to a media" do
      media = Media.create(title: "media title", kind: "picture")
      question = Question.create(content: "question ?", media_id: media.id)

      question.media.class.should eq(Media)
      question.media.title.should eq("media title")
    end
  end
end
