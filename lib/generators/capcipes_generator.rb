class CapcipesGenerator < ::Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  class_option :unicorn, type: :boolean, default: true

  def install
    template 'base.rake', 'lib/capistrano/tasks/base.rake'
  end

  def unicorn
    return unless options.unicorn?
    template 'unicorn.rake',    'lib/capistrano/tasks/unicorn.rake'
    template 'unicorn.rb',      'lib/capistrano/tasks/templates/unicorn.rb'
    template 'unicorn_init.sh', 'lib/capistrano/tasks/templates/unicorn_init.erb'
  end
end
