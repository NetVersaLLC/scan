set :branch, 'master'
set :rails_env, :staging
set :domain, ['ec2-50-17-135-19.compute-1.amazonaws.com']
ssh_options[:forward_agent] = true

role :web, *domain
role :app, *domain
role :db,  *domain, :primary => true