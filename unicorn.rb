# set path to app that will be used to configure unicorn,
# # note the trailing slash in this example
@dir = Dir.pwd

worker_processes 4
working_directory @dir

timeout 800

# # Specify path to socket unicorn listens to,
# # we will use this in our nginx.conf later
listen "#{@dir}/tmp/sockets/unicorn.sock", :backlog => 2048

# Set process id path
pid "#{@dir}/tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}/tmp/log/unicorn.stderr.log"
stdout_path "#{@dir}/tmp/log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|
  
  defined?(ActiveRecord::Base) and 
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
