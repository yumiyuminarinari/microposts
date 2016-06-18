module SessionsHelper
  def current_user
    # ・||=は左の値がfalseかnilの場合に右の値の代入を行います。変数を初期化する際によく用いられます。
    # ・||=で代入を行っているので、左側の@current_userに値が入っている場合は、右側のUser.find_byで始まる処理は実行されません。
    # 　すなわち、ログインしているユーザーを毎回DBに取りに行かなくてすみます。
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # current_userが存在する場合はtrueを、nilの場合はfalseを返します。
  def logged_in?
    #!!は、右側に続く値が存在する場合はtrueを、nilの場合はfalseを返します。
    # これは、否定演算子!を二回つかったものと考えることができます。
    # current_userが存在する場合、!current_userがfalseになり、もう一度!をつけるとfalseが反転してtrueになります。
    # current_userがnilの場合、!current_userがtrueになり、もう一度!をつけるとtrueが反転してfalseになります。
    !!current_user
  end

  # リクエストがGETの場合は、session[:forwarding_url]にリクエストのURLを代入しています。
  # ログインが必要なページにアクセスしようとした際に、
  # ページのURLを一旦保存しておき、ログイン画面に遷移して
  # ログイン後に再び保存したURLにアクセスする場合にこのメソッドを使用します。
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end