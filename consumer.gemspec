# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'evt-consumer'
  s.version = '0.9.0.2'
  s.summary = 'Consumer library that maintains a long running subscription to an event stream'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/consumer'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4.0'

  s.bindir = 'bin'

  s.add_runtime_dependency 'ntl-actor'

  s.add_runtime_dependency 'evt-configure'
  s.add_runtime_dependency 'evt-poll'
  s.add_runtime_dependency 'evt-messaging'

  s.add_development_dependency 'test_bench'
end
