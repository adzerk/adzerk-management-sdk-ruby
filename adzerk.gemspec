Gem::Specification.new do |s|
  s.name          = 'adzerk'
  s.version       = '0.1.4'
  s.summary       = "Adzerk API"
  s.description   = "Ruby library for the Adzerk API"
  s.files         = ['lib/adzerk.rb'] + Dir['lib/**/*.rb'] + Dir['test/*.rb']
  s.require_path  = 'lib'
  s.authors       = ["Kacy Fortner"]
  s.email         = "kacy@adzerk.com"
  s.homepage      = "http://adzerk.com"
  s.add_development_dependency "rspec", "= 2.11.0"
  s.add_runtime_dependency "json", "= 1.7.5"
  s.add_runtime_dependency "rest-client", "= 1.6.7"
end
