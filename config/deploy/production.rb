server "103.98.152.77", user: "root", roles: %w(web app db), primary: true

set :stage, :production
set :rails_env, :production
set :deploy_to, "/home/root/apps/project_s"
# default branch master
# set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: %w(../.ssh/bantk.pub)
}