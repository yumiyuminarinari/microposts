class UsersController < ApplicationController

  # edit,updateメソッドの前にset_messageを実行
  before_action :set_message, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # 上記と同じ動きをする
      # redirect_to user_path(@user)
    else
      render 'new'
    end
  end


  def edit
  end

  def update

    if @user.update(user_update_params)
      # nowを入れると一回だけ表示。そうじゃないと、メッセージが残る
      flash.now[:success] = "プロフィールを更新しました。"
      render 'edit'
    else
      @users = User.all
      flash.now[:danger] = "更新内容にエラーがあります。"
      render 'edit'
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :age, :address)
  end

  def set_message
    @user = User.find(params[:id])
  end

    # 正しいユーザーかどうかチェック
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end
