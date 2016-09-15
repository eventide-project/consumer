require_relative 'test_init'

path_spec = ARGV[1] || 'bench/**/*.rb'

TestBench::Runner.(
  path_spec,
  exclude_pattern: %r{/^skip_|(?:_init\.rb|\.sketch\.rb|_sketch\.rb|sketch\.rb|\.skip\.rb|_tests\.rb)\z}
) or exit 1
