class AdminassistancesController < ApplicationController
	
    before_action :set_user, only: [ :show, :edit]
before_action :in_check
def in_check
   if current_user.admin? || current_user.adminassistance? || current_user.client? || current_user.attorney?
    if current_user.lawfirm
    if current_user.lawfirm.status == "inactive" ||  current_user.lawfirm.status == nil
         redirect_to new_transaction_path, notice: 'Your Lawfirm Subscription has Expire Contact your Lawfirm Admin!'
      end
end
  end
 end
 
  def show
	@user = User.find(params[:id])
	 @user_cases = @user.mycases
end

def index
  @users = current_user.lawfirm.adminassistances
   
end
  
 
  
   def destroy
	@user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  

  
   def new
   @user = Adminassistance.new
 
  end
   def edit
     #@lawfirm = Lawfirm.find_by(params[:lawfirm_id])
    # @user=@lawfirm.users.find(params[:id])
 end
def update
    #@lawfirm = Lawfirm.find_by(params[:lawfirm_id])
     @user=Adminassistance.find_by(params[:id])

    @user.update(user_params)
    redirect_to root_path, notice: 'Adminasistance was successfully updated.' 
        
 end
  # POST /resource
  def create
	
   @user = current_user.lawfirm.adminassistances.create(user_params)
    
	 @user.save
        
	  respond_to do |format|
      if @user.save
        format.html { redirect_to  @user, notice: 'Successfully added a new Adminasistance.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        
      end
    end
	  
	  
  end
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = Adminassistance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:adminassistance).permit!
    end
  
end
