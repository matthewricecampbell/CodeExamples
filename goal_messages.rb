class GoalMessages
    attr_reader :goal
  
    def initialize(goal:)
      @goal = goal
    end
  
    def recently_created
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vestibulum sodales purus in maximus."
    end
  
    def recently_created_delayed
      MessagePersonalizer.new(user: user, message: message_base).personalize
    end
  
    def recently_updated
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit #{goal.number} Lorem ipsum dolor sit ame #{goal.pretty_regularity}!"
    end
  
    def met
      "Wow! Lorem ipsum dolor sit amet, consectetur adipr #{goal.pretty_regularity}lLorem ipsum dolor sit amet, consectetur adipiscing elit us!"
    end
  
    def progress_made
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit #{goal.pretty_regularity}Lorem ipsum dolor sit amet, consectetur adipiscing"
    end
  
    def no_progress_made
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit #{goal.pretty_regularity}Lorem ipsum dolor sit amet, consectetur adipiscing elit!"
    end
  
    private 
  
    def message_base
      "Lorem ipsum dolor sit amet, consectetur adipiscing #{goal.number} Lorem ipsum dolor sit amet #{goal.pretty_regularity}."
    end
  
    def user
      goal.goalable
    end
  end
  