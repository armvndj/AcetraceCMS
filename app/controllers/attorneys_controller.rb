class AttorneysController < ApplicationController
	
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
  def index
	#@users = User.all	
		@users = Attorney.all.paginate(page: params[:page], per_page: 10)
  end
  def lawfirm_attorneys
	#@users = User.all	
		@users = curent_user.lawfirm.attorneys.all.paginate(page: params[:page], per_page: 10)
  end
  def show
	@user = Attorney.find(params[:id])
	@user_cases = @user.mycases
	
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
   @user = Attorney.new
 
  end
   def edit
     #@lawfirm = Lawfirm.find_by(params[:lawfirm_id])
    # @user=@lawfirm.users.find(params[:id])
 end
def update
    #@lawfirm = Lawfirm.find_by(params[:lawfirm_id])
     @user=Attorney.find_by(params[:id])

    @user.update(user_params)
    redirect_to @user, notice: 'Attorney was successfully updated.' 
        
 end
  # POST /resource
  def create
	
   @user = current_user.lawfirm.attorneys.create(user_params)
    
	 @user.save
        
	  respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Successfully added a new Attorney profile.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        
      end
    end
	  
	  
  end
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = Attorney.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:attorney).permit!
    end
  
end
