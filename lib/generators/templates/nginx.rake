namespace :nginx do
  desc 'Links nginx config file'
  task :setup do
    on roles(:web) do
      unless package_exists?('nginx')
        execute :'apt-get', :update
        execute :'apt-get', 'install', '-y', '--force-yes', "nginx"
      end
      execute :mkdir, '-p', "/etc/nginx/sites-enabled"
      template  'nginx_unicorn.conf',
                "/etc/nginx/sites-enabled/#{fetch(:application)}"
    end
  end
  after 'deploy:symlink:linked_files', 'nginx:setup'

  %w(start stop restart).each do |command|
    desc "#{command} nginx"
    task command do
      on roles(:web) do
        execute "/etc/init.d/nginx #{command}"
      end
    end
  end
  after "deploy:restart", "nginx:restart"
end
