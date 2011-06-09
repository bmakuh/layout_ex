class Members::RequestsController < Members::MembersController
  filter_access_to :all
  before_filter :load_my_requests
  def index
    @requests = Request.find(:all, :order => 'from_date')
    @my_requests = Request.find_all_by_household_id(current_user.household.id)
    @pending_requests = PendingRequest.find(:all, :conditions => {:caregiver_requestor_id => current_user.id, :pending => "true"})
    @pending_requests.sort!{|a, b| a.request.from_date <=> b.request.from_date}
    
    @confirmed_requests = PendingRequest.find(:all, :conditions => {:caregiver_requestor_id => current_user.id, :confirmed => "true"})

    @num_volunteer_requests = PendingRequest.find(:all, :conditions => {:belongs_to_household_id => current_user.household.id, :pending => "true"}).count
    @num_neighbor_requests = Neighbor.find(:all, :conditions => {:household_id => current_user.household_id, :household_confirmed => false, :neighbor_confirmed => true}).count
    
    @hidden_requests = HiddenRequest.find_all_by_household_id(current_user.household.id)
    
    @num_neighbors = Neighbor.find(:all, :conditions => {:household_id => current_user.household.id, :household_confirmed => 't'}).count
  end

  def show
    @request = Request.find(params[:id])
  end
  
  def detail
    @request = Request.find(params[:id])
    @pending_request = PendingRequest.find(:all, :conditions => {:request_id => params[:id], :pending => "false", :caregiver_commit_id => current_user.id})
    @children = @request.children
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(params[:request])
    @request.household = current_user.household
    if @request.save
      flash[:success] = "Successfully created request."
      redirect_to members_request_path(@request)
    else
      render :action => 'new'
    end
  end

  def edit
    @request = Request.find(params[:id])
    @household = Request.find_by_household_id(@request.household_id)
    unless @request.household_id.eql? current_user.household_id
      flash[:error] = "You do not have permission to access this page."
      redirect_to members_request_path(@request)
    end
  end

  def update
    @request = Request.find(params[:id])
    params[:request][:child_ids] ||= []
    if !@request.household_id.eql? current_user.household_id
      flash[:error] = "You do not have permission to access this page."
      redirect_to members_request_path(@request)
    elsif @request.update_attributes(params[:request])
      flash[:success] = "Successfully updated request."
      redirect_to members_request_path(@request)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @request = Request.find(params[:id])
    @pending_requests = PendingRequest.find_all_by_request_id(@request.id)
    if !@request.household_id.eql? current_user.household_id
      flash[:error] = "You do not have permission to access this page."
      redirect_to members_request_path(@request)
    else
      @request.destroy
      for pending_request in @pending_requests
        pending_request.destroy
      end
      flash[:success] = "Successfully destroyed request."
      redirect_to members_profile_path
    end
  end
  
  def hide_request
    @hidden_request = HiddenRequest.new
    @hidden_request.request_id = params[:request_id]
    @hidden_request.household = current_user.household
    @hidden_request.belongs_to_household_id = params[:belongs_to]
    if @hidden_request.save
      flash[:success] = "You have hidden this request"
      redirect_to members_requests_path
    else
      flash[:error] = "There was an error hiding this post"
      redirect_to members_requests_path
    end
  end
  
  def hide_all_by_household
    @household = Household.find(params[:household_hidden_id])
    @hidden_request = HiddenRequest.new
    @hidden_request.household_hidden_id = params[:household_hidden_id]
    @hidden_request.household = current_user.household
    
    for hidden_request in HiddenRequest.all
      if hidden_request.belongs_to_household_id == @hidden_request.household_hidden_id && hidden_request.household == current_user.household
        hidden_request.destroy
      end
    end
    
    if @hidden_request.save
      flash[:success] = "You have hidden all by #{@household}"
      redirect_to members_requests_path
    else
      flash[:error] = "There was an error hiding requests from this household"
      redirect_to members_requests_path
    end
  end
  def load_my_requests
    @my_requests = Request.find_all_by_household_id(current_user.household.id)
    Request.my_requests = @my_requests
  end
end
