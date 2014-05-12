class User < ActiveRecord::Base

  acts_as_taggable_on :skills
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_messageable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :timeout_in => 60.minutes

  attr_accessor :login

  # has_many :conversations, dependent: :destroy
  has_one :timer, dependent: :destroy
  has_one :wrapper_group, class_name: "Group", dependent: :destroy
  has_many :campaigns, through: :wrapper_group, dependent: :destroy
  has_one :config, class_name: "UserConfig", dependent: :destroy
  has_many :skill_points, dependent: :destroy
  @group = Hash.new 
  has_one :timer, dependent: :destroy
  has_many :encounters, dependent: :destroy
  has_many :rounds, through: :encounters, dependent: :destroy
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :groups_where_admin_and_wrapper, class_name: "Group", join_table: "admins_groups"
  has_many :total_campaigns, through: :groups, source: :campaigns
  has_many :peers, through: :groups, source: :users
  belongs_to :active_quest, :class_name => 'Quest', :foreign_key => 'active_quest_id'
  after_create :new_user_setup
  #validates :username,
  #  :uniqueness => {
  #    :case_sensitive => false
  #  },
  #  :format => /[A-Za-z]/
  #

  # Will check for authentication based on the Devise library
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first  
    end
  end

  def pending_deadlines(days_in_future=7)
    Quest.where( 'campaign_id in (?)', self.campaigns.pluck(:id) ).where('deadline < (?)', days_in_future.days.from_now ).order(deadline: :desc)
  end


  # Will return only groups where the user does not have admin privileges
  def groups_where_member
    self.groups-self.groups_where_admin_and_wrapper
  end

  # Will return only groups where the user is admin, excluding their private
  # wrapper group, preventing manipulation of that permanant group
  def groups_where_admin
    self.groups_where_admin_and_wrapper - [ self.wrapper_group ]
  end

  # Will return all groups less the wrapper group
  def groups_less_wrapper
    self.groups - [ self.wrapper_group ]
  end

  # Will add a user to a group with member privileges
  def add_group_as_member(group)
    self.groups.push group
  end 
  
  # Will make a current group member into an administrator
  def promote_in_group( group )
    self.groups_where_admin_and_wrapper.push group
  end

  # Will simultaneously add a user to a group and promote them to admin
  def add_group_as_admin(group)
    add_group_as_member group
    promote_in_group group
  end

  # Will remove a group from the user's membership list
  def remove_group(group)
    self.groups.destroy group 
  end
  
  # Will ensure a user has all associated models created
  # Will create a timer model to save the state of their workflow
  # Will create a wrapper group to manage privacy of their campaigns
  # Will create a user_config to manage their settings
  # Will create a default campaign as a catch-all to-do list
  def new_user_setup
    self.create_timer
    self.groups.create( {name: self.username})
    g=self.groups.first
    self.wrapper_group=g
    self.promote_in_group g
    cam=Campaign.create({ name: "My Journey", description: "A collection of to-dos and notes that don't fit anywhere else", group_id: g.id, status: "Open"})
    q=Quest.create({name: "Unsorted Musings", description: "A place to store those notes that doen't fit elsewhere", parent_id: cam.id, campaign_id: cam.id, group_id: g.id, status: "Open"})
    enc = Encounter.create({ user: self})
    enc.end_time = Time.now.utc
    enc.rounds << Round.create({ type: 'Campaign', event_id: cam.id, event_description: 'create', encounter_id: enc.id, campaign: cam})
    enc.rounds << Round.create({ type: 'Quest', event_id: q.id, event_description: 'create', encounter_id: enc.id, campaign: cam})
    q=Quest.create({name: "To Do's", description: "A place to store those notes that doen't fit elsewhere", parent_id: cam.id, campaign_id: cam.id, group_id: g.id, status: "Open"})
    self.active_quest=q
    self.save
    self.reload
    enc.end_time = Time.now.utc
    enc.rounds << Round.create({ type: 'Quest', event_id: q.id, event_description: 'create', encounter_id: enc.id, campaign: cam})
    enc.save

    UserConfig.create({
      user_id: self.id,
      auto_timer: true,
      encounter_duration: 25*60,
      short_break_duration: 5*60,
      extended_break_duration: 15*60,
      encounter_extend_duration: 5*60,
      timezone_name: "US/Eastern",
      utc_time_offset: -14400
    })
  end

  def self.addGroup(groupName, isAdmin)
    @group[groupName] = isAdmin
 
  end

  # Will check if user session is expired
  # @return [bool] Returns true if user session is expired
  def expired?
    if user.where(:username => current_user).where(:expiration_time) < Time.now

    end
  end

  # Will request account deletion
  # @return [void]
  def deleteRequest

  end

  # Will generate a paginated collection encounters for the user
  # @param end_time [datetime] last time included in list of encounters
  # end_time will default to the current time.
  # @return [collection] first page of encounters preceeding end_time
  # 
  def timeline( end_time=Time.now )
    Encounter.where('user_id = (?)',self.id).where('created_at <= (?)', end_time)
  end

  # Will return the last encounter for the user
  # @return [encounter] last encounter
  def last_encounter
    Encounter.where(:user_id => self.id).last
  end

  # Will return an authentication token for github access
  def github
    @github = Github.new client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995'
  end

  # Will Setup message username
  def message_user
    return self.username
  end

  def message_email(object)
    if instance_of? User
      return self.email
    else
      return nil
    end

  end

end
