set :application, "RemoteFlix"
set :repository,  "git@github.com:moyarada/RemoteFlix.git"

set :user, "rflix"
set :deploy_to, "/home/rflix/app/"
set :use_sudo, false
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :stack, :passenger_nginx

ssh_options[:forward_agent] = true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "remoteflix.tv"                          # Your HTTP server, Apache/etc
role :app, "remoteflix.tv"                          # This may be the same as your `Web` server




#role :db,  "mongo", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end