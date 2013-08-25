Gem::Specification.new do |s|
  s.name         = 'autobrewster'
  s.version      = '0.0.1'
  s.date         = '2013-08-24'
  s.summary      = 'CSS regression testing suite'
  s.description  = 'Combines PhantomJS and Imagemagick to provide screenshot-based comparison for CSS regression testing'
  s.authors      = ['Chris Blackburn']
  s.email        = 'chris@madebymade.co.uk'
  s.files        = ['lib/auto_brewster.rb', 'bin/autobrewster']
  s.license      = 'BSD'
  s.homepage     = 'https://github.com/madebymade/autobrewster'

  s.require_path = 'lib'
  s.bindir       = 'bin'

  s.executables  = ['autobrewster']

  s.add_dependency             'thin'
  s.add_development_dependency 'rspec',   '~> 2.0'
  s.add_development_dependency 'sinatra', '~> 1.4'

  ignores  = File.readlines('.gitignore').grep(/\S+/).map(&:chomp)
  dotfiles = %w[.gitignore .travis.yml .editorconfig]
end
