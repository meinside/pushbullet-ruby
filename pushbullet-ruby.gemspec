# last update: 2014.12.18.

Gem::Specification.new do |s|
  # version/date
  s.version     = '0.0.1'
  s.date        = '2014-12-18'

  # project info
  s.name        = 'pushbullet-ruby'
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Ruby library for Pushbullet'
  s.description = 'Ruby library for Pushbullet\'s HTTP API (https://docs.pushbullet.com/http/)'
  s.files       = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.license     = 'MIT'

  # dependencies
  s.add_dependency('mimemagic', '~> 0.0')

  # profile
  s.authors     = ['Sungjin Han']
  s.email       = 'meinside@gmail.com'
  s.homepage    = 'http://github.com/meinside/pushbullet-ruby'
end

