require 'role_model'
# User class as handled through the devise gem
class User < ActiveRecord::Base

  acts_as_taggable_on :skills
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessor :login

  has_one :timer
  has_many :skill_pointses
  @group = Hash.new 
  has_one :group, as: :user_group
  has_one :timer
  has_many :encounters
  has_and_belongs_to_many :groups
  belongs_to :active_quest, :class_name => 'Quest', :foreign_key => 'active_quest_id'
  after_create :new_user_setup
  #validates :username,
  #  :uniqueness => {
  #    :case_sensitive => false
  #  },
  #  :format => /[A-Za-z]/
  #

  # Devise check for authentication
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first  
    end
  end


  def new_user_setup
    self.create_timer
    cam=Campaign.create({ name: "My Journey", description: "A collection of to-dos and notes that don't fit anywhere else", user_id: self.id, status: "Open"})
    q=Quest.create({name: "Unsorted Musings", description: "A place to store those notes that doen't fit elsewhere", parent_id: cam.id, campaign_id: cam.id, user_id: self.id, status: "Open"})
    self.active_quest=q
    self.save
    self.reload
    enc = Encounter.create({ user: self})
    enc.end_time = Time.now.utc
    enc.rounds << Round.create({ type: 'Campaign', event_id: cam.id, event_description: 'create', encounter_id: enc.id, campaign: cam})
    enc.rounds << Round.create({ type: 'Quest', event_id: q.id, event_description: 'create', encounter_id: enc.id, campaign: cam})
    enc.save
  end

  def self.addGroup(groupName, isAdmin)
    @group[groupName] = isAdmin
 
  end

  #
  # TODO
  # Add notification
  # Add expiration
  #


  # Check if user session is expired
  # @return [bool] Returns true if user session is expired
  def expired?
    if user.where(:username => current_user).where(:expiration_time) < Time.now

    end
  end


  # Request for deletion
  # @return [void]
  def deleteRequest

  end

  # Generates a paginated collection encounters for the user
  # @param end_time [datetime] last time included in list of encounters
  # end_time defaults to the current time.
  # @return [collection] first page of encounters preceeding end_time
  # 
  def timeline( end_time=Time.now )
    Encounter.where('user_id = (?)',self.id).where('created_at <= (?)', end_time)
  end

  # Get last encounter for the user
  # @return [encounter] last encounter
  def last_encounter
    Encounter.where(:user_id => self.id).last
  end
end
