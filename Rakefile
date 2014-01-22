# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

DIR = File.dirname __FILE__

namespace :remote do

  task :restart do
    sh %{ssh juergen@juergenalbertsen.de "sudo /etc/init.d/storyteller restart"}
  end

  task :copy do
    sh "cd #{DIR} && rsync -rltvz --delete --exclude-from=config/rsync_excludes.txt . juergen@juergenalbertsen.de:/var/www/www.juergenalbertsen.de"
  end
  
  task :deploy => [ :copy, :restart ]
  
end