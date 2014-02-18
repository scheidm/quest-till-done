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



end
