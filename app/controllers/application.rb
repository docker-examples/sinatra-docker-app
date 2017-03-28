class MdaApi < Sinatra::Base
  get '/' do 
    "Ask for documentation"
  end

  error Exception do 
    render_generic_exception
  end  

  error ActiveRecord::RecordNotFound do 
    render_record_not_found
  end

  error ArgumentError do 
    render_invalid_argument
  end

  error ActiveRecord::RecordInvalid do 
    render_record_invalid
  end 

  not_found do 
    routing_error
  end
end
