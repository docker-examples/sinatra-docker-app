require 'sinatra'
require 'sinatra/activerecord'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'simple_redis_cache'
require 'axlsx'
require 'sidekiq'

ActiveRecord::Base.raise_in_transactional_callbacks = true
use ActiveRecord::QueryCache if ENV['RACK_ENV'] == 'production'
TIME_ZONE = 'Kuala Lumpur' #'Riyadh'
HOST_PATH = "http://207.46.236.253/"


DEFAULT_CACHE_TIME = 15
CACHE_FOR_7_DAYS = 3600 * 22 * 7

Time.zone = TIME_ZONE
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.time_zone_aware_attributes = true


$LOAD_PATH.unshift(File.dirname(__FILE__), 'app', 'uploaders')
require File.join(File.dirname(__FILE__), 'app', 'uploaders', 'init.rb')

$LOAD_PATH.unshift(File.dirname(__FILE__), 'app', 'models')
require File.join(File.dirname(__FILE__), 'app', 'models', 'init.rb')


$LOAD_PATH.unshift(File.dirname(__FILE__), 'app', 'reports')
require File.join(File.dirname(__FILE__), 'app', 'reports', 'init.rb')

$LOAD_PATH.unshift(File.dirname(__FILE__), 'app', 'helpers')
require File.join(File.dirname(__FILE__), 'app', 'helpers', 'init.rb')
require 'workers/worker'

set :public_folder, Proc.new{ File.join(root, 'public') }
set :views, false

# sidekiq confiure client
Sidekiq.configure_client do |config|
  config.redis = { url: "redis://192.168.99.100:6379" }
end

# redis cache config
SimpleRedisCache::Config.redis =  Redis.new(url: 'redis://192.168.99.100:6379')

class SinatraApi < Sinatra::Base

  set :export_email, 'abc@gmail.com' #'anupam.hore@asia.xchanging.com'
  set :show_exceptions, false
  disable :sessions

  configure :development, :test do
    require 'pry'
  end

  helpers ApplicationHelper, AuthenticationHelper

  configure :development do
    set :logging, Logger::DEBUG
  end

  configure :production do
    set :logging, Logger::INFO
  end

  before do
    set_cache_headers
    set_build_header
  end

  before /^(?!\/(\/|auth\/login|auth\/signup|users_list|latest_app|beacon|log_location|admin\/([\w|\W]+)))/ do
    logger.info "---------Request Params------------"
    logger.info params.inspect
    logger.info "---------Request Body -------------"
    logger.info JSON.parse(request.body.read.to_s).inspect rescue nil
    authenticate!
    render_error(message: 'Unauthorized access', status: 401) and return  unless @current_user
    @current_user.refresh_time
  end

end

$LOAD_PATH.unshift(File.dirname(__FILE__), 'lib', 'notifications')
require File.join(File.dirname(__FILE__), 'lib', 'notifications', 'notification.rb')

$LOAD_PATH.unshift(File.dirname(__FILE__), 'app', 'controllers')
require File.join(File.dirname(__FILE__), 'app', 'controllers', 'init.rb')

