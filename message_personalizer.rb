class MessagePersonalizer
    attr_reader :user, :message
  
    def initialize(user:, message:)
      @user = user
      @message = message
    end
  
    def personalize
      if user.first_name.present?
        "Hey #{user.first_name.capitalize}, #{message}"
      else
        message
      end
    end
  end
  