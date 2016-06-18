class StaticPagesController < ApplicationController
  def home
    # ログインしている場合は、新しいMicropostクラスのインスタンスをuser_idを紐付けた状態で初期化
    @micropost = current_user.microposts.build if logged_in?
  end
end
