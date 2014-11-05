namespace :database do
  desc "Generate the database.yml configuration file."
  task :setup do
    on roles(:app) do
      unless package_exists?('libpq-dev')
        execute :'apt-get', 'install', 'libpq-dev', '-y'
      end
      template "database.yml", "#{shared_path}/config/database.yml"
    end
  end
  before "deploy:check", "database:setup"
end
