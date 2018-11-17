class NewCaseMailer < ApplicationMailer
	default from: 'info@acetracecms.com'
	def new_case_email(user, mycase)
    	@user = user
    	@mycase = mycase
    	mail(to: @user.email, subject: 'New Case Has been created')
  	end
end

