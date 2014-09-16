web: bundle exec unicorn -p $PORT -E $RACK_ENV -c ./config/unicorn.rb
resque: env QUEUE=* bundle exec rake resque:work
