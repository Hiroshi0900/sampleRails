module SessionsHelper

	# ログインメソッド
	def log_in(user)
		session[:user_id] = user.id
	end
	# ユーザーをセッションの永続的にする
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# 現在ログイン中のユーザーを返す
	def current_user
		if(user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
			end
		end
	end
	# ユーザーがログインしてればtrue,その他ならfalseを返す
	def logged_in?
		!current_user.nil?
	end
	# ログアウトメソッド
	def log_out
		session.delete(:user_id)
		@current_user = nil
	end

	# 永続的なセッションを破棄する
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(remember_token)
	end
end
