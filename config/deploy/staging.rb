set :branch, 'production'
set :rails_env, :staging
set :domain, ['ec2-54-234-206-170.compute-1.amazonaws.com']
ssh_options[:forward_agent] = true

role :web, *domain
role :app, *domain
role :db,  *domain, :primary => true