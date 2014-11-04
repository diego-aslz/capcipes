Gem::Specification.new do |s|
  s.name        = 'capcipes'
  s.version     = '0.0.1'
  s.date        = '2014-11-04'
  s.summary     = "Capistrano Recipes for Rails."
  s.description = "This gem provides a generator to install common Capistrano"\
    " recipes."
  s.authors     = ["Diego Aguir Selzlein"]
  s.email       = 'diegoselzlein@gmail.com'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.homepage    = 'https://github.com/nerde/capcipes'
  s.license     = 'MIT'
end
