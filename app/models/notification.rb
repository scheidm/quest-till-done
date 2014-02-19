# Notification class for sending notifications
class Notification
  #Notification Level 0 as disabled
  N_DISABLED = 0
  #Notification Level 0 as issue watch
  N_PARTICIPATING = 1
  #Notification Level 0 as project watch
  N_WATCH = 2
  #Notification Level 3 as global
  N_GLOBAL = 3

  attr_accessor :target

  # Defining Notification Level
  # @return [Integer] Notification Level
  def self.notification_levels
    [N_DISABLED, N_PARTICIPATING, N_WATCH]
  end

  # Define Project Notification Level
  # @return [Integer] Project Notification Level
  def self.project_notification_levels
    [N_DISABLED, N_PARTICIPATING, N_WATCH, N_GLOBAL]
  end

  # Initialize notification target, this defines where to send
  # @param [String] target Notification Levels
  def initialize(target)
    @target = target
  end

  # Check if the notification system is disabled
  # @return [Integer]
  def disabled?
    target.notification_level == N_DISABLED
  end

  # Check if user is in group notification
  # @return [Integer]
  def participating?
    target.notification_level == N_PARTICIPATING
  end

  # Check if user is watch a project or issue
  # @return [Integer]
  def watch?
    target.notification_level == N_WATCH
  end

  # Check if the user is setting for global notification
  # @return [Integer]
  def global?
    target.notification_level == N_GLOBAL
  end
end
