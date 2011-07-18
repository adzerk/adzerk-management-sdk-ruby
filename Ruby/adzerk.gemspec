spec = Gem::Specification.new do |s|
  s.name = 'adzerk'
  s.version = '0.1'
  s.summary = "Ruby library for the Adzerk API"
  s.description = %{Ruby library for the Adzerk API}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = 'builder'
  s.has_rdoc = false
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'Adzerk Ruby Library'
  s.author = "Kacy Fortner"
  s.email = "kacy@adzerk.com"
  s.homepage = "http://adzerk.com"
end