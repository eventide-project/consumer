# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'consumer'
  s.version = '0.0.0.0'
  s.summary = 'Consumer library that maintains a long running subscription to an event stream'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/consumer'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.bindir = 'bin'

  # FIXME: After rubygems releases its next version, it will be possible to
  # depend upon the actor gem that is published to fury.io/ntl, which will
  # allow the `ntl-` prefix to be removed here. This is the commit that must be
  # released in order to make this change:
  #
  #   https://github.com/rubygems/rubygems/commit/aa663c8f45ae88ff97440e16f144f93a984165c0
  #
  # [Nathan Ladd, Thu 15 Sep 2016]
  s.add_runtime_dependency 'ntl-actor'

  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'settings'
  s.add_runtime_dependency 'telemetry'
  s.add_runtime_dependency 'telemetry-logger'
  s.add_runtime_dependency 'initializer'

  s.add_development_dependency 'event_store-client-http'
  s.add_development_dependency 'test_bench'
end
