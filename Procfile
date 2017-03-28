web: RACK_ENV=$ENV unicorn -p $PORT
#web: unicorn -c unicorn.rb -p $PORT
worker: bundle exec sidekiq -r ./workers/worker.rb
