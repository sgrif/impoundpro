class UserMailer < ActionMailer::Base
  
  def welcome(user, login_url)
    @user = user
    @login_url = login_url
    mail(:to => @user.email, :subject => "Welcome to impoundpro.com")
  end
  
  def password_reset(user)
    @user = user
    
    mail :to => @user.email, :subject => "Password reset for impoundpro.com"
  end
  
  def password_changed(user)
    @user = user
    
    mail :to => @user.email, :subject => "impoundpro.com password changed"
  end
end
