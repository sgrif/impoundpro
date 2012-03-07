class UserMailer < ActionMailer::Base
  default :from => "noreply@impoundpro.com"
  
  def welcome(user, login_url)
    @user = user
    @login_url = login_url
    mail(:to => user.email, :subject => "Welcome to impoundpro.com")
  end
end
