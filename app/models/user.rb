require 'role_model'
# User class
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
  has_and_belongs_to_many :groups
  belongs_to :active_quest, :class_name => 'Quest', :foreign_key => 'active_quest_id'
  after_create :create_timer
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
end
