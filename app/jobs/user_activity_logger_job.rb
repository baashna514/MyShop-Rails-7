class UserActivityLoggerJob < ApplicationJob
  queue_as :default

  def perform(user_id, action)
    UserActivity.create(
      user_id: user_id,
      action: action,
      timestamp: Time.now
    )
  end
end
