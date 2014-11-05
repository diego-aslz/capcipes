class CapcipesGenerator < ::Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  class_option :unicorn, type: :boolean, default: true
  class_option :database, type: :string, default: 'mysql'

  def install
    template 'base.rake', 'lib/capistrano/tasks/base.rake'
  end

  def unicorn
    return unless options.unicorn?
    template 'unicorn.rake',    'lib/capistrano/tasks/unicorn.rake'
    template 'unicorn.rb',      'lib/capistrano/tasks/templates/unicorn.rb'
    template 'unicorn_init.sh', 'lib/capistrano/tasks/templates/unicorn_init.erb'
  end

  def database
    template  "database_#{options.database}.rake",
              'lib/capistrano/tasks/database.rake'
    template  "database_#{options.database}.yml",
              'lib/capistrano/tasks/templates/database.yml'
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
