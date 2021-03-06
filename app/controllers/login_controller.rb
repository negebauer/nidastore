class LoginController < ApplicationController
  skip_before_action :user_session_required, only: [:ask, :validate, :reset_password]

  def ask
    user_id = session[:user_id]
    if !user_id.nil? && User.exists?(user_id)
      redirect_to profile_path
    end
  end

  def validate
    username = params[:username]
    password = params[:password]
    user, @error = User.login(username, password)
    if @error
      render 'ask'
    else
      session[:user_id] = user.id
      redirect_to root_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  def reset_password

  end
end
