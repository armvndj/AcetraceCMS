class StaticPagesController < ApplicationController
before_action :in_check
def in_check
  if current_user.admin? || current_user.adminassistance? || current_user.client? || current_user.attorney?
    if current_user.lawfirm
    if current_user.lawfirm.status == "inactive" ||  current_user.lawfirm.status == nil
         redirect_to new_transaction_path, notice: 'Your Lawfirm Subscription has Expire Contact your Lawfirm Admin!'
      end
      else
        redirect_to new_lawfirm_path, notice: 'Setup Your Lawfirm First'

end
  end

 end
def payment_history
  if current_user.admin? 
    if current_user.lawfirm.transactions
    @ress = current_user.lawfirm.transactions
  end
end

end


  def home
    if current_user.admin?
      if current_user.lawfirm == nil
       
        redirect_to new_lawfirm_path, notice: 'Admin Account was succesfully created. You have to set up your Lawfirm'
      end
      end
      @usersalls=User.all
      @user=current_user
      @mycases = Mycase.all
  @lawfirms = Lawfirm.all
  @admins = Admin.all
    lawfirmusers
   if current_user.admin? || current_user.attorney? || current_user.client?
    
    @user_cases ||= []
    if current_user.mycases.any?
       current_user.mycases.each do |u| 
        if u.client_id == current_user.id 
     @user_cases << u
      end
    end
  end
    end

    if current_user.admin?
         if current_user.lawfirm.transactions.any?
              rem = (current_user.lawfirm.transactions.last.expires_on - Date.today).to_s.split('/')
              @offset = rem[0].to_i

          end

    end


  if current_user.sadmin?
      paystackObj = Paystack.new(ENV['PUBLIC_KEY'], ENV['SECRET_KEY'])
      transactions = PaystackTransactions.new(paystackObj)
      @total = transactions.totals()
  end
end

    def subscribers
      @lawfirms = Lawfirm.where(status: 1).all.paginate(page: params[:page], per_page: 5)
    end

      def lawfirmusers
         if current_user.admin? || current_user.adminassistance? || current_user.client? || current_user.attorney?
     if current_user.lawfirm
    if current_user.lawfirm.mycases || current_user.lawfirm.clients || current_user.lawfirm.attorneys|| current_user.lawfirm.adminassistances
     @lawfirm_users ||= []
      @lawfirm_cases = current_user.lawfirm.mycases
      @clients = current_user.lawfirm.clients
      
       @lawfirm_adminassistance = current_user.lawfirm.adminassistances
       @lawfirm_attorneys= current_user.lawfirm.attorneys
    
 @lawfirm_adminassistance.each do |u| 
     @lawfirm_users << u
    
    end

    @lawfirm_attorneys.each do |u| 
     @lawfirm_users << u
    
    end

    @clients.each do |u| 
     @lawfirm_users << u
    
    end

    @lawfirm_users << current_user

      end
    end
  end
  end
  def lawfirmcases
    home
  end
   def attorneycases
    home
  end
   def clientcases
    home
  end

  def clients
    lawfirmusers  
end

  def admins
    home 
end



def attorneys
  lawfirmusers
  
 end


end

