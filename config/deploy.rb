set :application, "social_devotional"
set :repository,  "git@bitbucket.org:chip_miller/social-devotional.git"

set :scm, :git

role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

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

namespace :deploy do
  before "deploy:symlink", "deploy:sidekiq_stop"
  after "deploy:symlink", "deploy:sidekiq_start"

  task :sidekiq_start do
    run "(test -e /etc/init.d/prebuy_sidekiq && /etc/init.d/prebuy_sidekiq start) || $(exit 0)"
    sleep 5
  end

  task :sidekiq_stop do
    run "(test -e /etc/init.d/prebuy_sidekiq && /etc/init.d/prebuy_sidekiq stop) || $(exit 0)"
    sleep 5
  end
end