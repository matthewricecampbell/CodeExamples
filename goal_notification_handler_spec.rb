require "rails_helper"

describe GoalNotificationHandler do
  context 'newly created goals' do
    describe "#handle" do
      it "should be 1 minute with correct message" do
        user = create :user
        goal = create :goal, goalable: user
        service = GoalNotificationHandler.new(goal: goal, state: Goal::STATES['recently_created'])
        handler = service.handlers[0]

        expect(handler).to include("Way to go!")
      end

      it "should be 48 hours with correct message" do
        user = create :user
        goal = create :goal, goalable: user
        service = GoalNotificationHandler.new(goal: goal, state: Goal::STATES['recently_created'])
        handler = service.handlers[1]

        expect(handler.delay_time).to eq(48.hours)
        expect(handler.message).to include("Now's the perfect")
      end
    end
  end

  context 'updating a goal' do
    describe "#handle" do
      it "should be 1 minute with correct message" do
        user = create :user
        goal = create :goal, goalable: user
        Timecop.travel(Time.now + 20)
        goal.update(number: 2)
        service = GoalNotificationHandler.new(goal: goal, state: Goal::STATES['recently_updated'])
        handler = service.handlers[0]

        expect(handler).to include("Nice, your goal")
      end
    end
  end

  context 'completing a goal' do
    describe "#handle" do
      it "should be 1 minute with correct message" do
        nfi = create :need_fulfill_intent
        user = nfi.user
        goal = create :goal, goalable: user, number: 1, regularity: 'monthly'
        Timecop.travel(Time.now + 20)
        service = GoalNotificationHandler.new(goal: goal, state: Goal::STATES['met'])
        handler = service.handlers[0]

        expect(handler).to include("Wow! Looks like you’ve met your")
      end
    end
  end

  context 'has made progress on a goal' do
    describe "#handle" do
      it "should be 1 minute with correct message" do
        nfi = create :need_fulfill_intent
        user = nfi.user
        goal = create :goal, goalable: user, number: 5, regularity: 'monthly'
        Timecop.travel(Time.now + 20)
        service = GoalNotificationHandler.new(goal: goal, state: Goal::STATES['progress_made'])
        handler = service.handlers[0]

        expect(handler).to include("Great job! It seems you’re making progress towards your monthly")
      end
    end
  end

  context 'has NOT made progress on a goal' do
    describe "#handle" do
      it "should be 1 minute with correct message" do
        user = create :user
        goal = create :goal, goalable: user, number: 5, regularity: 'monthly'
        Timecop.travel(Time.now + 20)
        service = GoalNotificationHandler.new(goal: goal, state: Goal::STATES['no_progress_made'])
        handler = service.handlers[0]

        expect(handler).to include("Right now is the perfect")
      end
    end
  end
end
