Gem::Specification.new do |s|
  s.name      = 'rack-ssl'
  s.version   = '1.3.3'
  s.date      = '2013-01-29'

  s.homepage    = "https://github.com/josh/rack-ssl"
  s.summary     = "Force SSL/TLS in your app."
  s.description = <<-EOS
    Rack middleware to force SSL/TLS.
  EOS

  s.files = [
    'lib/rack/ssl.rb',
    'LICENSE',
    'README.md'
  ]

  s.add_dependency 'rack'

  s.authors           = ["Joshua Peek"]
  s.email             = "josh@joshpeek.com"
  s.rubyforge_project = 'rack-ssl'
end
