namespace :secrets do
  desc "Generate the secrets.yml configuration file."
  task :setup do
    on roles(:app) do
      file = "#{shared_path}/config/secrets.yml"
      template "secrets.yml", file unless test("[ -f #{file} ]")
    end
  end
  before "deploy:check", "secrets:setup"
end
