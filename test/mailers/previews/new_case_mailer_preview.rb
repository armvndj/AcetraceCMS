# Preview all emails at http://localhost:3000/rails/mailers/new_case_mailer
class NewCaseMailerPreview < ActionMailer::Preview
	def new_case_mail_preview
    	NewCaseMailer.new_case_email(User.first, Mycase.first)
  	end
end
