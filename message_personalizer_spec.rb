require "rails_helper"

describe MessagePersonalizer do
  describe "#personalize" do
    context "if first name available" do
      it "should call add first name to message" do
        user = create :user, first_name: "Bob"
        service = MessagePersonalizer.new(user: user, message: "Right about now...")

        expect(service.personalize).to eq("Hey Bob, Right about now...")
      end
    end

    it "should return message passed in message" do
        user = create :user, first_name: ""
        service = MessagePersonalizer.new(user: user, message: "Right about now...")

        expect(service.personalize).to eq("Right about now...")
    end
  end
end