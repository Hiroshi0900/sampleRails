class SessionsController < ApplicationController
  def new
  end
  def create
	user = User.find_by(email:params[:session][:email].downcase)
	if user && user.authenticate(params[:session][:password])
		# #ログイン成功
		log_in user
		# ログイン状態を保存するかチェックボックスで変更する
		params[:session][:remember_me] == '1' ? remeber(user) : forget(user)
		# redirect_to user
		redirect_back_or user
	else
		flash.now[:danger] = 'Invalid email/password combination'
		render 'new'
	end
  end
  def destroy
	# ログイン中ならログアウト状態にする
	log_out if logged_in?
	redirect_to root_url
  end
end

