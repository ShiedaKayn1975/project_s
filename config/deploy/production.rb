server "103.98.152.77", user: "ubuntu", roles: %w(web app db), primary: true

set :stage, :production
set :rails_env, :production
set :deploy_to, "/home/ubuntu/apps/project_s"
# default branch master
# set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: %w(../.ssh/bantk)
}