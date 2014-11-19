namespace :database do
  desc "Generate the database.yml configuration file."
  task :setup do
    on roles(:app) do
      install_package 'libpq-dev'
      # Uncomment if you use postgres extensions
      # install_package 'postgresql-contrib'
      template "database.yml", "#{shared_path}/config/database.yml"
    end
  end
  before "deploy:check:linked_files", "database:setup"
end
