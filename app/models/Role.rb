class Role
	include CanCan::Role
	@group = Hash.new
	def initialize(user)
		@group= User.group
	end
end