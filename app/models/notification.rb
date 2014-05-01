class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def source
    self.source_type.singularize.classify.constantize.find(self.event_id)
  end

  def target
    self.target_type.singularize.classify.constantize.find(self.target_id)
  end

  def admin
    User.find self.authorization_id
  end

  def mark_read

  end

  def mark_dismissed

  end

  def mark_group_invite_accept

  end

  def link_models( source, target )
    self.source_id = source.id
    self.source_type = source.class.name
    self.target_id = target.id
    self.target_type = target.class.name
  end

end
