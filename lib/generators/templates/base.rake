def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  upload! StringIO.new(ERB.new(erb).result(binding)), to
end

def package_exists?(name)
  test("dpkg -l | grep #{name} > /dev/null")
end

def install_package(name)
  execute :'apt-get', 'install', name, '-y' unless package_exists?(name)
end
