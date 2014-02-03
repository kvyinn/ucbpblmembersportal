class UserMailer < ActionMailer::Base
  default from: "davidbliu@gmail.com"
  def blog_email(member, post)
  	@member = member
  	@post = post
  	if member.old_member
  		mail(:to => member.old_member.email, :subject => "new blogpost homie!")
  	end
  end
end
