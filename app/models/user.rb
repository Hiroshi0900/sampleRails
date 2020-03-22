class User < ApplicationRecord
	# セッション変数を操作する
	attr_accessor :remember_token, :activation_token
	before_save   :downcase_email
	before_create :create_activation_digest
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }	,allow_nil: true
	
	# ランダムなトークンを返す
	def User.new_token
		SecureRandom.urlsafe_base64
	end
	# 永続セッションのためにDBに格納する
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest , User.digest(remember_token))
	end
	# 文字列のハッシュ値を返す
	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
		        BCrypt::Engine.cost
	end
	# ランダムなトークンを返す
	# 上との違いはself(自分自身を値として投げる？？)を使ってる
	# selfはクラスメソッド
	
	# トークンがダイジェストと一致したらtrueを返す
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
	# ユーザーのログイン情報を破棄する
	def forget
		update_attribute(:remember_digest , nil)
	end

	# メール送信
	private
		# メールアドレスを全て小文字にする
		def downcase_email
			self.email = email.downcase
		end

	    # 有効化トークンとダイジェストを作成・代入する
	    def create_activation_digest
	    	self.activation_token  = User.new_token
	    	self.activation_digest = User.digest(activation_token)
	    end
end
