class UsersController < ApplicationController

  # edit,updateメソッドの前にset_messageを実行
  before_action :set_message, only: [:edit, :update, :destroy, :edit_address, :edit_address_complete]
  before_action :correct_user,   only: [:edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
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

  def edit_address
    # 指定したrenderでviewを作成する
    render 'edit_address_test'
  end

  def edit_address_complete

    if @user.update(user_update_params)
      # nowを入れると一回だけ表示。そうじゃないと、メッセージが残る
      flash.now[:success] = "プロフィールを更新しましたよ。"
      # viewのファイル名を指定する
      render 'edit_address_test'
    else
      @users = User.all
      flash.now[:danger] = "更新内容にエラーがありますよ。"
      # viewのファイル名を指定する
      render 'edit_address_test'

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

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    return redirect_to root_url if @micropost.nil?
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.follower
    render 'show_follow'
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
