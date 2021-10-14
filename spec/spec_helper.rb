require 'rspec'
require 'rspec-benchmark'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

RSpec.configure do |config|
  config.include RSpec::Benchmark::Matchers
end
