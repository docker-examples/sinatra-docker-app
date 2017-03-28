module ApplicationHelper
  
  def search_params
    per_page = 50
    params[:search] ||= {}
    params[:search][:page] ||= 1
    params[:search][:per_page] = per_page
    if params[:search][:page].to_i.zero?
      params[:search][:offset] = 0
    else
      params[:search][:offset] = (params[:search][:page].to_i - 1) * per_page
    end
  end

  def app_auth_method
    'bearer'
  end

  def api_version
    '0.1'
  end

  def build_version
    '01'
  end

  def current_user
    @current_user
  end

  def cache_options(hash)
    hash.collect{ |k,v| "#{k}-#{v}"}.join('-')
  end

  # API errors. You can pass:
  #  :message
  #  :description
  #  :status
  def render_error(options)
    error =  options[:message] || env['sinatra.error'].message
    status = options[:status] || 400
    
    halt status, { 'Content-type' => 'application/json; charset=utf-8' }, error 
  end

  # 404 error message
  def routing_error
    render_error message: 'The server has not found anything matching the Request-URI.', status: 404
  end

  def set_cache_headers
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
  end

  def set_build_header
    response.headers['X-API-Version'] = "#{api_version} build.#{build_version}"
  end

  # CUSTOM EXCEPTION HANDLING
  def render_record_not_found
    render_error message: 'Record not found'
  end

  def render_record_invalid
    render_error message: 'Unable to process request'
  end

  def render_generic_exception
    render_error(
      message: "An error that we didn't expect. We will look in to it!",
      status: 500
    )
  end

  def render_invalid_argument
    render_error message: 'invalid argument'
  end

end
