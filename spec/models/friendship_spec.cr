require "./spec_helper"
require "../../src/models/friendship.cr"

describe Friendship do
  Spec.before_each do
    Friendship.clear
  end

  describe "validations" do
    describe "status" do
      %w(pending accepted rejected).each do |status|
        describe status do
          it "is valid" do
            Friendship.create(status: status).valid?.should eq(true)
          end
        end
      end

      describe "other status" do
        it "is not valid" do
          Friendship.create(status: "IDK").valid?.should eq(false)
        end
      end
    end
  end
end
