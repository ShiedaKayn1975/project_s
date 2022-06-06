# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

set :application, "project_s"
set :repo_url, "https://github.com/ShiedaKayn1975/project_s"

set :rvm_type, :system                # Defaults to: :auto
# set :rvm_ruby_version, '2.7.1'      # Defaults to: 'default'
# set :rvm_custom_path, '~/.myveryownrvm'  # only needed if not detected

set :deploy_to, "/home/ubuntu/apps/project_s"
set :pty,             true
set :stage,           :production
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord

set :linked_files, fetch(:linked_files, []).push("config/master.key")
append :linked_files, ".env"
append :linked_dirs, "public"
append :linked_dirs, "storage"
append :linked_dirs, "log", "tmp/pids", "tmp/cache"

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     invoke 'puma:restart'
  #   end
  # end

  # after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  # after  :finishing,    :restart
end
