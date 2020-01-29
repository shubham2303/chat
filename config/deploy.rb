#
# set :application, 'chat_server'
# set :repo_url, 'git@github.com:shubham2303/chat.git' # Edit this to match your repository
# set :branch, :master
# set :deploy_to, '/home/deploy/chat'
# set :pty, true
# set :linked_files, %w{config/database.yml config/application.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
# set :keep_releases, 5
# set :rvm_type, :user
# set :rvm_ruby_version, 'jruby-1.7.19' # Edit this if you are using MRI Ruby
#
# set :puma_rackup, -> { File.join(current_path, 'config.ru') }
# set :puma_state, "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
# set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
# set :puma_conf, "#{shared_path}/puma.rb"
# set :puma_access_log, "#{shared_path}/log/puma_error.log"
# set :puma_error_log, "#{shared_path}/log/puma_access.log"
# set :puma_role, :app
# set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
# set :puma_threads, [0, 8]
# set :puma_workers, 0
# set :puma_worker_timeout, nil
# set :puma_init_active_record, true
# set :puma_preload_app, false
#
# config valid only for current version of Capistrano
lock '3.11.2'

set :application, 'chat'
set :repo_url, 'git@github.com:shubham2303/chat.git'
set :deploy_to, "/home/deploy/#{fetch(:application)}"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

set :stage, :production

# Default value for :pty is false
set :pty, true

# set :rvm_type, :user                     # Defaults to: :auto
# set :rvm_ruby_version, '2.2.1'      # Defaults to: 'default'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/puma.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :puma_threads,        		[16, 64]
set :puma_workers,        		8
set :puma_bind,           		"unix://#{shared_path}/tmp/sockets/#{fetch(:application)}.sock"
set :puma_state,          		"#{shared_path}/tmp/pids/#{fetch(:application)}.state"
set :puma_pid,            		"#{shared_path}/tmp/pids/#{fetch(:application)}.pid"
set :puma_conf,           		"#{shared_path}/config/puma.rb"
set :puma_access_log,     		"#{release_path}/log/puma.access.log"
set :puma_error_log,     		  "#{release_path}/log/puma.error.log"
set :puma_role,           		:app
set :puma_env,            		fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_preload_app,    		true
set :puma_worker_timeout,     nil
set :puma_init_active_record, true

# set :whenever_environment, defer { stage }
# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# set :whenever_command, 'bundle exec whenever'

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  # before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
      execute "sudo service nginx restart"
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :restart
end