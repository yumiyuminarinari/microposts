class MicropostsController < ApplicationController
  # ApplicationControllerにあるlogged_in_userメソッドを実行し、
  # ログインしていない場合はcreateメソッドは実行しないで/loginにリダイレクト
  before_action :logged_in_user, only: [:create]

  # パラメータを受け取って現在のユーザーに紐付いたMicropostのインスタンスを作成して@micropost変数に入れ、
  # @micropost.saveで保存が成功した場合は、root_urlである/にリダイレクトを行い、
  # 失敗した場合はapp/views/static_pages/home.html.erbのテンプレートを表示
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    return redirect_to root_url if @micropost.nil?
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
