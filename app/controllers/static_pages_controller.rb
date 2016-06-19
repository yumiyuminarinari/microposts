class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # 新しいMicropostクラスのインスタンスをuser_idを紐付けた状態で初期化
      @micropost  = current_user.microposts.build
    end
  end
end
