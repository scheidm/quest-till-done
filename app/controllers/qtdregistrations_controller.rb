class QtdregistrationsController < Devise::RegistrationsController
  def edit
    @user = User.find(current_user.id)
    super
  end

  def update
    @user = User.find(current_user.id)
    super
  end
end
