module AuthenticationHelper
  def authenticate!
    auth_header = request.env["HTTP_AUTHORIZATION"]
     
    # Check if auth header is present
    if auth_header.nil? || (auth_header.split.size != 2)
      response.headers['WWW-Authenticate'] = 'Bearer realm="Secure API"'
      body 'unauthorized'
      status 401
      return
    end

    # Get header values
    auth_method, access_token = auth_header.split[0..1]

    # Check if auth type is Bearer
    render_error message: "Unsupported authorization type. Use 'Authorization: Bearer [token]'" and
      return if auth_method.downcase != app_auth_method

    # is token a jwt?
    if access_token =~ /\A[^\.]+\.[^\.]+\.[^\.]+\z/
      begin
        decoded_token = JWTService.decode(access_token)
      rescue
        render_error message: 'invalid_grant' and return
      end

      render_error message: 'invalid_grant' and return if JWTService.expired?(decoded_token)

      # this will need to be changed in a future story...
      # current_user should not be a User object but instead an array of mailbox_ids
      @current_user = User.find(decoded_token[0]["user_id"])
    else
      # Find Token
      #user = SinatraApi.cache.fetch("/token/access_token/#{access_token}", expires_in: 1.hour) do
      @current_user = User.find_by(access_token: access_token)
      #end

      render_error message: 'invalid_grant' and return if (@current_user.nil? || @current_user.token_expired?)

    end
  end

end
