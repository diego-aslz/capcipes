class CapcipesGenerator < ::Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def install
    template 'base.rake', 'lib/capistrano/tasks/base.rake'
  end
end
