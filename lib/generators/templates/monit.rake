namespace :monit do
  desc "Install Monit"
  task :install do
    on roles(:app, :web) do
      install_package 'monit'
    end
  end
  before "deploy", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    monit_config "monitrc", "/etc/monit/monitrc"
<% if options.nginx? %>
    Rake::Task["monit:nginx"].execute
<% end %>
<% if options.unicorn? %>
    Rake::Task["monit:unicorn"].execute
<% end %>
    Rake::Task["monit:syntax"].execute
    Rake::Task["monit:restart"].execute
  end
  after "deploy:symlink:linked_files", "monit:setup"

  task(:nginx)   { monit_config "nginx"  , nil, :web }
  task(:unicorn) { monit_config "unicorn", nil, :app }

  %w[start stop restart syntax].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:app, :web) do
        execute "service monit #{command}"
      end
    end
  end
end

def monit_config(name, destination = nil, roles_hash = :web)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  on roles(roles_hash) do
    template "monit/#{name}.erb", "/tmp/monit_#{name}"
    execute "mv /tmp/monit_#{name} #{destination}"
    execute "chown root #{destination}"
    execute "chmod 600 #{destination}"
  end
end
