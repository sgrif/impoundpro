set :user, 'griffinassoc'
set :domain, 'impoundpro.com'
set :application, "Tyler"

set :repository,  "#{user}@#{domain}:git/impoundpro.git"
set :deploy_to, "/home/#{user}/#{domain}"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'feature/bootstrap'
set :scm_verbose, true
set :use_sudo, false
set :rails_env, :production
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

default_run_options[:pty] = true

role :web, domain # Your HTTP server, Apache/etc
role :app, domain # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

namespace :deploy do
#  desc "cause Passenger to initate a restart"
#  task :restart do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
  
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
end

after "deploy:update_code", :bundle_install, :copy_sensitive_files
desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install --without test"
end

desc "copy config files containing sensitive information"
task :copy_sensitive_files, :roles => :app do
  run "cp #{shared_path}/database.yml #{release_path}/config/database.yml;"
  run "cp #{shared_path}/stripe.rb #{release_path}/config/initializers/stripe.rb;"
end

before "deploy:restart", :mod_cgi
desc "make dispatch.fcgi executable"
task :mod_cgi, :roles => :app do
  run "chmod +x #{release_path}/public/dispatch.fcgi"
end

after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
