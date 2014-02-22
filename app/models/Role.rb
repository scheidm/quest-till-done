# Permissioning as managed through the cancan gem.
class Role
	include CanCan::Role
	def initialize(user)
		@group= User.group
	end
end
