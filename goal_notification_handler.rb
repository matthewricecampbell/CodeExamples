class GoalNotificationHandler
    attr_reader :goal, :state, :goal_messages
  
    def initialize(goal:, state:)
      @goal          = goal
      @state         = state
      @goal_messages = GoalMessages.new(goal: goal)
    end
  
    def handle
      handlers.each do |handler|
        message = handler.try(:message) || handler
        delay_time = handler.try(:delay_time) || 1.minute
        PushNotificationJob.set(wait_until: delay_time).
          perform_later(notification_params(message))
      end
    end
  
    def handlers
      {
        recently_created:            [
          goal_messages.recently_created,
          OpenStruct.new(delay_time: 48.hours, message: goal_messages.recently_created_delayed)
        ],
        recently_updated:            [goal_messages.recently_updated],
        met:                         [goal_messages.met],
        progress_made:               [goal_messages.progress_made],
        no_progress_made:            [goal_messages.no_progress_made]
      }[state]
    end
  
  
    private
      def notification_params(message)
        {
          "headings"          => {"en" => "Purposity Goal"},
          "contents"          => {"en" =>  message},
          "data"              => { "destScreen" => "ProfileScreen"},
          "include_player_ids" => [user]
        }
      end
  
      def user
        goal.goalable.player_id
      end
  end