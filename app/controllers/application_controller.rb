class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :store_location


  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # rescue_from CanCan::AccessDenied, with: :access_denied


  def index
    flash.notice = 'No page found at that address'
    redirect_to root_path
  end


  def store_location
# store last url – this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don’t store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    if resource.class.name == "User"
      if current_user.sign_in_count == 1
        users_update_path
      else
        session[:previous_url] || root_path
      end
    else
      admin_dashboard_path
    end
  end

  def after_sign_up_path_for(resource)
    resource.class.name == "User" ? new_user_session_path : admin_dashboard_path
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] = nil
    root_path
  end


  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  # def access_denied_admin(exception)
  #   redirect_to admin_dashboard_path, alert: exception.message
  # end

  protected
  def record_not_found
    redirect_to root_path
  end


end

