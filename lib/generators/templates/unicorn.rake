set :unicorn_user,    'root'
set :unicorn_pid,     '/tmp/unicorn.<%= application_name %>.pid'
set :unicorn_workers, 2

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    on roles(:app) do
      set :unicorn_config, "#{shared_path}/config/unicorn.rb"
      set :unicorn_log,    "#{shared_path}/log/unicorn.log"

      template "unicorn.rb", fetch(:unicorn_config)
      template "unicorn_init.sh", "/tmp/unicorn_init"
      execute :chmod, '+x', "/tmp/unicorn_init"
      execute :mv, "/tmp/unicorn_init /etc/init.d/#{fetch(:application)}"
      execute :'update-rc.d', '-f', "#{fetch(:application)} defaults"
    end
  end
  after "deploy:symlink:linked_files", "unicorn:setup"

  %w[restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:app) do
        execute "/etc/init.d/#{fetch(:application)} #{command}"
      end
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end
