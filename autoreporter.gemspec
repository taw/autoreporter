Gem::Specification.new do |s|
  s.name         = "autoreporter"
  s.version      = "0.0.20230707.1"
  s.date         = "2023-07-07"
  s.summary      = "Command line report runner"
  s.authors      = ["Tomasz Wegrzanowski"]
  s.email        = 'Tomasz.Wegrzanowski@gmail.com'
  s.files        = Dir["lib/*"] + Dir["bin/*"]
  s.executables  = ["autoreporter"]
  s.homepage     = "https://github.com/taw/autoreporter"
  s.license      = "MIT"
  s.add_runtime_dependency "optimist"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
