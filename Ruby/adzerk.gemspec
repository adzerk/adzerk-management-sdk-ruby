Gem::Specification.new do |s|
  s.name          = 'adzerk'
  s.version       = '0.1.4'
  s.summary       = "Adzerk API"
  s.description   = "Ruby library for the Adzerk API"
  s.files         = ['lib/Adzerk.rb'] + Dir['lib/**/*.rb'] + Dir['test/*.rb']
  s.require_path  = 'lib'
  s.authors       = ["Kacy Fortner"]
  s.email         = "kacy@adzerk.com"
  s.homepage      = "http://adzerk.com"
end