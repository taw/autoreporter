Gem::Specification.new do |s|
  s.name         = "autoreporter"
  s.version      = "0.0.20160509.1"
  s.date         = "2016-05-09"
  s.summary      = "Command line report runner"
  s.authors      = ["Tomasz Wegrzanowski"]
  s.email        = 'Tomasz.Wegrzanowski@gmail.com'
  s.files        = Dir["lib/*"] + Dir["bin/*"]
  s.homepage     = "https://github.com/taw/autoreporter"
  s.license      = "MIT"
  s.add_runtime_dependency "trollop"
end
