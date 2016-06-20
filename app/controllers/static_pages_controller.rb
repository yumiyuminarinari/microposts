class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # ログインしている場合は、新しいMicropostクラスのインスタンスをuser_idを紐付けた状態で初期化
      @micropost = current_user.microposts.build

      # feed_itemsで現在のユーザーのフォローしているユーザーのマイクロポストを取得し、
      # (created_at: :desc)で作成日時が新しいものが上にくるように並び替え
      # includes(:user)の部分は、つぶやきに含まれるユーザー情報をあらかじめ先読み（プリロード）する処理を行うため。
      # これにより、@feed_itemsからアイテムを取り出すたびに、それに紐付いたユーザーの情報をDBから取り出さずに済みます。
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
    end
  end
end
