class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	# セッションヘルパー宣言
	include SessionsHelper

    def hello
        render html:"hello,world"
    end
end
