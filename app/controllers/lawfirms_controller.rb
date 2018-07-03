class LawfirmsController < ApplicationController
  skip_before_action :verify_authenticity_token
 #load_and_authorize_resource :lawfirm
  before_action :set_lawfirm, only: [:activate_lawfirm, :deactivate_lawfirm, :show, :edit, :update, :destroy]
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
  # GET /lawfirms
  # GET /lawfirms.json
  def index
    @lawfirms = Lawfirm.all.paginate(page: params[:page], per_page: 5)
    
  end

  def show
  end

  def activate_lawfirm
    @lawfirm.update(status: 1)
   redirect_to @lawfirm, notice: 'Lawfirm was successfully activated.' 
  end

  def deactivate_lawfirm
    @lawfirm.update(status: 0)
    redirect_to @lawfirm, notice: 'Lawfirm was successfully deactivated.'
        
  end

  # GET /lawfirms/new
  def new
    @lawfirm = Lawfirm.new
  end

  # GET /lawfirms/1/edit
  def edit
  end

  # POST /lawfirms
  # POST /lawfirms.json
  def create
    @lawfirm = Lawfirm.new(lawfirm_params)
    @lawfirm.admin_id= current_user.id
    #current_user.lawfirm = @lawfirm
    @lawfirm.status = 0
    @lawfirm.save
    respond_to do |format|
      if @lawfirm.save
        format.html { redirect_to @lawfirm, notice: 'Lawfirm was successfully created. Welcome to Acetracecms!' }
        format.json { render :show, status: :created, location: @lawfirm }
      else
        format.html { render :new }
        format.json { render json: @lawfirm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lawfirms/1
  # PATCH/PUT /lawfirms/1.json
  def update
    respond_to do |format|
      if @lawfirm.update(lawfirm_params)
        format.html { redirect_to @lawfirm, notice: 'Lawfirm was successfully updated.' }
        format.json { render :show, status: :ok, location: @lawfirm }
      else
        format.html { render :edit }
        format.json { render json: @lawfirm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lawfirms/1
  # DELETE /lawfirms/1.json
  def destroy
    @lawfirm.destroy
    respond_to do |format|
      format.html { redirect_to lawfirms_url, notice: 'Lawfirm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lawfirm
      @lawfirm = Lawfirm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lawfirm_params
      params.require(:lawfirm).permit(:status, :interval, :name,:logos,:remove_logos, :logos_cache, :type_of_organization, :address, :email, :phone_number, :state, :city)
    end
	 #resourcify
end
