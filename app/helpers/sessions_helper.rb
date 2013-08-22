module SessionsHelper

  def current_member
    @current_member ||= Member.where(remember_token: cookies[:remember_token]).first if cookies[:remember_token]
  end

end
