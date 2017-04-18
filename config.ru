if ENV['RACK_ENV'] == 'production' 
  require 'unicorn/worker_killer'
  
  max_request_min =  100
  max_request_max =  200
  
  use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max
   
  oom_min = (120) * (1024**2)
  oom_max = (130) * (1024**2)

  use Unicorn::WorkerKiller::Oom, oom_min, oom_max

end

require File.join(File.dirname(__FILE__), 'app')

set :run, false

#set :environment, :production

run SinatraApi
