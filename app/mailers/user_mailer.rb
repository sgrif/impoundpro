class UserMailer < ActionMailer::Base
  
  def welcome(user)
    @user = user

    mail(:to => @user.email, subject: "Welcome to impoundpro.com")
  end
  
  def password_reset(user)
    @user = user
    
    mail to: @user.email, subject: "Password reset for impoundpro.com"
  end
  
  def password_changed(user)
    @user = user
    
    mail to: @user.email, subject: "impoundpro.com password changed"
  end
end
