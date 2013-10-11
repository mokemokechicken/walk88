class UserRecordsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user_record, only: [:show, :edit, :update, :destroy, :sync_fitbit]

  # GET /user_records
  # GET /user_records.json
  def index
    user_id = (params[:user_id] || current_user.id).to_i
    @owner = user_id == current_user.id
    @user = User.find(user_id)
    @user_setting = @user.user_setting
    @user_records = UserRecord.where(user_id: user_id).
        paginate(:page => params[:page], :per_page => 14).order('day desc')
  end

  # GET /user_records/1
  # GET /user_records/1.json
  def show
  end

  # GET /user_records/new
  def new
    @user_record = UserRecord.new
    @user_setting = current_user.user_setting
  end

  # GET /user_records/1/edit
  def edit
    @user_setting = current_user.user_setting
  end

  # POST /user_records
  # POST /user_records.json
  def create
    record_params = user_record_params
    record_params[:user_id] = current_user.id
    @user_record = UserRecord.new(record_params)
    if UserRecord.exists?(user_id: @user_record.user_id, day: @user_record.day)
      @user_record = UserRecord.find_by(user_id: @user_record.user_id, day: @user_record.day)
      return update
    end

    respond_to do |format|
      if @user_record.save
        format.html { redirect_to user_records_url, notice: '保存しました' }
        format.json { render action: 'show', status: :created, location: @user_record }
        on_update
      else
        format.html { render action: 'new' }
        format.json { render json: @user_record.errors, status: :unprocessable_entity }
      end
    end
  end

  def on_update
    UserStatus.update_user_status(current_user.id)
  end

  def sync_fitbit
    if current_user.id == @user_record.user_id
      setting = current_user.user_setting
      client = Fitbit.create_client
      client.reconnect(setting.fitbit_token, setting.fitbit_secret)
      info = Fitbit.fetch_info_by_day(client, @user_record.day.to_s)
      unless info[:errors]
        @user_record.update_attributes(
            steps: info[:step].to_s.to_i,
            distance: info[:dist].to_s.to_f
        )
        on_update
      end
      render json: info
    else
      render json: {error: 'Not Permittied'}
    end
  end

  # PATCH/PUT /user_records/1
  # PATCH/PUT /user_records/1.json
  def update
    return redirect_to root_url unless @user_record.user_id == current_user.id
    respond_to do |format|
      if @user_record.update(user_record_params)
        format.html { redirect_to user_records_url, notice: '保存しました' }
        format.json { head :no_content }
        on_update
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_records/1
  # DELETE /user_records/1.json
  def destroy
    return redirect_to root_url unless @user_record.user_id == current_user.id
    @user_record.destroy
    on_update
    respond_to do |format|
      format.html { redirect_to user_records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_record
      @user_record = UserRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_record_params
      params.require(:user_record).permit(:day, :steps, :distance)
    end
end
