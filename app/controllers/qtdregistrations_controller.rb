class QtdregistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    authors_waiting_path
  end

  def new
    super
  end

  def create
    super
  end

  def edit
    @user = User.find(current_user.id)
    super
  end

  def update
    @user = User.find(current_user.id)
    super
  end
end
