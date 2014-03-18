# Class responsible for generating email for registered users
class UserMailer < ActionMailer::Base
  default from: "admin@qtd.com"

  # Sends the default welcome email for email validation of new users
  def welcome_email(user)
      @user = user
      @url  = 'http://qtd.com/login'
      mail(to: @user.email, subject: 'Welcome to QTD')
  end
  
end
