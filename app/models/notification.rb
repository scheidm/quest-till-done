class Notification < ActiveRecord::Base

  #Source will be any arbitrary rails Model, stored by source_type and source_id
  #in the database. this function will reconstruct the actual source object from
  #those fields.
  def source
    self.source_type.singularize.classify.constantize.find(self.event_id)
  end

  #Target will be any arbitrary rails Model, stored by source_type and source_id
  #in the database. this function will reconstruct the actual target object from
  #those fields.
  def target
    self.target_type.singularize.classify.constantize.find(self.target_id)
  end

  #This function will return the user who authorized the action listed in the
  #notification, for the purpose of record keeping for group management.
  def admin
    User.find self.authorization_id
  end

  #This function will store any 2 arbitrary models as source and target on a
  #newly created notification
  #@param source [Object] originating side of request, often a user or group
  #@param target [Object] receiving side of request, will always be a user
  def link_models( source, target )
    self.source_id = source.id
    self.source_type = source.class.name
    self.target_id = target.id
    self.target_type = target.class.name
  end

end
