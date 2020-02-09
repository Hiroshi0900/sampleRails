module SessionsHelper

	# ログインメソッド
	def log_in(user)
		session[:user_id] = user.id
	end
	# ログインユーザーを返す
	def current_user
		if session[:user_id]
			@current_user ||= User.find_by(id:session[:user_id])
		end
	end
	# ユーザーがログインしている場合はtrue,してなければfalseを返す
	def logged_id?
		!current_user.nil?
	end
end
