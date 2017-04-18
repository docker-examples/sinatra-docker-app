class SinatraApi < Sinatra::Base

  post '/auth/login' do
    params[:user] ||= {}
    @current_user ||= User.authenticate(params[:user][:username], params[:user][:password])
    render_error message: "invalid username or password" and return unless @current_user
    render_error message: "User is is inactive."  and return unless @current_user.active
    token = @current_user.generate_token
    @current_user.auth_details.to_json()
  end 

  post '/auth/signup' do
    params[:user] ||= {}
    @current_user = User.authenticate(params[:user][:username], params[:user][:old_password])
    render_error message: "invalid username or old password" and return unless @current_user
    render_error message: "User is is inactive."  and return unless @current_user.active
    render_error message: @current_user.errors.to_json and return unless @current_user.signup(params[:user]) 
    token = @current_user.generate_token
    @current_user.auth_details.to_json()
  end 

  put '/auth/change_password' do
    auth_header = request.env["HTTP_AUTHORIZATION"]||""
    auth_method, access_token = auth_header.split[0..1]
    @current_user ||= User.find_by(access_token: access_token)
    render_error message: 'Invalid change password token' and return unless @current_user
    if @current_user.signup(params[:user])
      'success'
    else  
      render_error message: @current_user.errors.to_json, status: 422
    end
  end 

  delete '/auth/logout' do
    auth_header = request.env["HTTP_AUTHORIZATION"]||""
    auth_method, access_token = auth_header.split[0..1]
    @current_user ||= User.find_by(access_token: access_token)
    render_error message: 'Invalid logout token' and return unless @current_user
    if @current_user.logout
      'success'
    else  
      render_error message: @current_user.errors.to_json, status: 422
    end
  end 

  post '/auth/ping' do
    'success'
  end
    
end
