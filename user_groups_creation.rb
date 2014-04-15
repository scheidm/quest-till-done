Group.all.destroy_all
User.all.each do |u|
  u.groups.create( {id: u.id, name: u.username})
  u.group_id=u.groups.first.id
  u.save
end
