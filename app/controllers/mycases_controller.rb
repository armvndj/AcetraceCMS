class MycasesController < ApplicationController
  skip_before_action :verify_authenticity_token
  #skip_before_action :authenticate_user!, :only => [:index, :show]
  before_action :set_mycase, only: [:assign_attorney, :new_assign, :casetask, :meet, :show, :edit, :update, :destroy]
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
  # GET /mycases
  # GET /mycases.json
  def index
    @mycases = Mycase.all
  end

  # GET /mycases/1
  # GET /mycases/1.json
  def show
	 @mycase = Mycase.find(params[:id])

	 @client = User.find_by id: @mycase.client_id
	@attorneys = @mycase.users
		respond_to do |format|
      format.html
     format.pdf do
          @example_text = "some text"
          render :pdf => "cetracecms_legalcase_file_pdf"
                 
	#@user_lawfirm = @user.lawfirm
	#@user_cases = @user.mycases
end
end
  end
  def assign_attorney
    @mycase.update_attributes(mycase_params)
    #@mycase.update(mycase_params)
    #@attorney_user = User.find_by(params[:user_id])
     # @mycase.users << @attorney_user
      
     @mycase.save
     if @mycase.users.any?
      @mycase.users.each do |f|
          Notification.create(
          notify_type: 'mention',
          actor: current_user,
          user: f,
          target: @mycase)
      end
    end
  
  Notification.create(
          notify_type: 'update',
          actor: current_user,
          user: @mycase.client,
          target: @mycase)
       respond_to do |format|
      if @mycase.save
        format.html { redirect_to @mycase, notice: 'Attorney was successfully Assinged.' }
        format.json { render :show, status: :ok, location: @mycase }
      else
        format.html { render :edit }
        format.json { render json: @mycase.errors, status: :unprocessable_entity }
      end
    end

  end

  def new_assign
    
    newcase
  end

  def inview
     @mycase = Mycase.find(params[:id])
      
      @mycase.update(status: 1)
       respond_to do |format|
      if @mycase.update(status: 1)
         if mycase.users.any?
      @mycase.users.each do |f|
          Notification.create(
          notify_type: 'update',
          actor: current_user,
          user: f,
          target: @mycase)
      end
    end
    Notification.create(
          notify_type: 'update',
          actor: current_user,
          user: @mycase.client,
          target: @mycase)
    Notification.create(
          notify_type: 'update',
          actor: current_user,
          user: @mycase.admin,
          target: @mycase)
        format.html { redirect_to @mycase, notice: 'Mycase was successfully updated.' }
        format.json { render :show, status: :ok, location: @mycase }
      else
        format.html { render :edit }
        format.json { render json: @mycase.errors, status: :unprocessable_entity }
      end
    end
  end


def completed
  @mycase = Mycase.find(params[:id])
     # @company =  Company.find(params[:company_id])
      
      @mycase.update(status: 2)
       respond_to do |format|
      if @mycase.update(status: 2)
         if mycase.users.any?
      @mycase.users.each do |f|
          Notification.create(
          notify_type: 'update',
          actor: current_user,
          user: f,
          target: @mycase)
      end
    end
    Notification.create(
          notify_type: 'update',
          actor: current_user,
          user: @mycase.admin,
          target: @mycase)
        format.html { redirect_to @mycase, notice: 'Mycase was successfully updated.' }
        format.json { render :show, status: :ok, location: @mycase }
      else
        format.html { render :edit }
        format.json { render json: @mycase.errors, status: :unprocessable_entity }
      end
    end
end
   def casetask
  #@user = Mycase.find_by id: user_id
	
	# @user = User.find_by id: @mycase.user_id
	#@attorney_user = User.find_by id: @mycase.attorney_id
	
		#@attorney_user = @mycase.attorney_user
	#user = Challenge.find_by id: id_value
  end
  
  def meet
  #@user = Mycase.find_by id: user_id
	
	 #@user = User.find_by id: @mycase.client_id
	#@attorney_user = User.find_by id: @mycase.attorney_id
	
		#@attorney_user = @mycase.attorney_user
	#user = Challenge.find_by id: id_value
  end
  
	
  
  

  # GET /mycases/new
  def new
	@lawfirm = current_user.lawfirm

	@mycase=Mycase.new
  newcase
  
end

def newcase
  @attorneys=current_user.lawfirm.attorneys
  @clients = current_user.lawfirm.clients
  @admin = current_user.lawfirm.admin

end
 
  def add_attorney
	@attorney = User.find(params[:attorney_id])
    @mycase = @attorney.mycases.biuld
  end
 
  # GET /mycases/1/edit
  def edit
    newcase
  end

  # POST /mycases
  # POST /mycases.json
  def create  
    @client = Client.find_by(params[:client_id])
    @admin =  current_user.lawfirm.admin   
   #build admin as a user to create notofication to admin  
   
  
      @mycase = @client.mycases.create(mycase_params)
    
      @lawfirm = current_user.lawfirm
      @mycase.lawfirm_id=  @lawfirm.id
      @mycase.admin_id = @admin.id
    @mycase.status= 0
  #@mycase= @attorney_user.mycases.build(mycase_params)
   
   
  
  
 @mycase.save
      respond_to do |format|
        if @mycase.save
           Notification.create(
      notify_type: 'mention',
      actor: current_user,
      user: @admin,
      target: @mycase)

    Notification.create(
      notify_type: 'mention',
      actor: current_user,
      user: @client,
      target: @mycase)
        format.html { redirect_to @mycase, notice: 'Legal Case was successfully created.' }
        format.json { render :show, status: :ok, location: @mycase }
        else
          newcase
        format.html { render :new }
        format.json { render json: @mycase.errors, status: :unprocessable_entity }
   
     end
    end

  end



 

  # PATCH/PUT /mycases/1
  # PATCH/PUT /mycases/1.json
  def update
  
    respond_to do |format|
      if @mycase.update_attributes(mycase_params)
        format.html { redirect_to @mycase, notice: 'Mycase was successfully updated.' }
        format.json { render :show, status: :ok, location: @mycase }
      else
        format.html { render :edit }
        format.json { render json: @mycase.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /mycases/1
  # DELETE /mycases/1.json
  def destroy
    @mycase.destroy
    @mycase.notify :users, key: "Legal Case Deleted, you are associated"
    respond_to do |format|
      format.html { redirect_to mycases_url, notice: 'Legal Case was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
   

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mycase
      @mycase = Mycase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mycase_params

      params.require(:mycase).permit!
    end
end

