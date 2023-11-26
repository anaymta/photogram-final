class ApplicationController < ActionController::Base
  
  before_action :authenticate_user!,  {:alert => "You need to sign in/sign up before you can continue."}

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [:username, :password, :private])

    devise_parameter_sanitizer.permit(:account_update, :keys => [:password, :private, :username])
  end
end
