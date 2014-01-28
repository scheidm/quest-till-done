class UserMailer < ActionMailer::Base
  default from: "admin@qtd.com"
  
  def welcome_email(user)
      @user = user
      @url  = 'http://qtd.com/login'
      mail(to: @user.email, subject: 'Welcome to QTD')
  end
  
end
