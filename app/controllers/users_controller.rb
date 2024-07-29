class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!, except: [:index, :show]
  before_action :correct_admin, only: [:edit, :update, :destroy, :create, :new]
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    # @user = User.new
    @user = current_admin.users.build
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create

    Rails.logger.debug "correct_admin: #{correct_admin.inspect}"
    # @user = User.new(user_params)
    @user = correct_admin.users.build(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def correct_admin
    Rails.logger.debug "Current Admin: #{current_admin.inspect}"
    @user = current_admin.users.find_by(id: params[:id])
    redirect_to users_path, notice: "Not Authorize to edit this User." if @user.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :twitter, :admin_id)
    end
end
