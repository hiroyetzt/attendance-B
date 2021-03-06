class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :show, :update]
  before_action :correct_user, only: [:edit, :update]
  
  
  
  def new
    @user = User.new
  end
  
  def show
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "登録しました。"
      redirect_to @user
    else
      flash[:danger] = "登録に失敗しました。"
      render :new
    end 
  end
  
  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "更新しました。"
      redirect_to @user
    else 
      flash[:danger] = "更新に失敗しました。"
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeフィルター
    def set_user
      @user = User.find(params[:id])
    end
    #ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end 
    end
      
      #アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end 
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end




