#! /bin/bash

export ENV=production
bundle 
bundle exec rake db:migrate
kill $(ps aux | grep -E 'sidekiq|unicorn|foreman' | grep -v grep | awk '{print $2}')
foreman start &
