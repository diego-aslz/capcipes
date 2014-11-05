class CapcipesGenerator < ::Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  class_option :unicorn,  type: :boolean, default: true
  class_option :nginx,    type: :boolean, default: true
  class_option :monit,    type: :boolean, default: true
  class_option :database, type: :string,  default: 'mysql'

  def install
    template 'base.rake',    'lib/capistrano/tasks/base.rake'
    template 'secrets.rake', 'lib/capistrano/tasks/secrets.rake'
    template 'secrets.yml',  'lib/capistrano/tasks/templates/secrets.yml'
  end

  def unicorn
    return unless options.unicorn?
    template 'unicorn.rake',    'lib/capistrano/tasks/unicorn.rake'
    template 'unicorn.rb',      'lib/capistrano/tasks/templates/unicorn.rb'
    template 'unicorn_init.sh', 'lib/capistrano/tasks/templates/unicorn_init.erb'
  end

  def nginx
    return unless options.nginx?
    template  'nginx.rake', 'lib/capistrano/tasks/nginx.rake'
    template  'nginx_unicorn.conf',
              'lib/capistrano/tasks/templates/nginx_unicorn.conf'
  end

  def database
    template  "database_#{options.database}.rake",
              'lib/capistrano/tasks/database.rake'
    template  "database_#{options.database}.yml",
              'lib/capistrano/tasks/templates/database.yml'
  end

  def monit
    return unless options.monit?
    template 'monit.rake',    'lib/capistrano/tasks/monit.rake'
    template 'monit/monitrc', 'lib/capistrano/tasks/templates/monit/monitrc'
    %w(nginx unicorn).each do |monit|
      next unless options.send("#{monit}?")
      template "monit/#{monit}", "lib/capistrano/tasks/templates/monit/#{monit}"
    end
  end

  protected

  def application_name
    if defined?(Rails) && Rails.application
      Rails.application.class.name.split('::').first.underscore
    else
      "application"
    end
  end
end
