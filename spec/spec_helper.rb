require 'pry'

# This will check if i required all `activerecord/core_ext`s i need
require 'active_support/all' unless ENV['TRAVIS']

if ENV['COVERAGE_ROOT']
  require 'simplecov'

  SimpleCov.start do
    minimum_coverage 100
    coverage_dir ENV['COVERAGE_ROOT']
    add_group 'Library', 'lib'
  end
end

require 'xconfig'

RSpec.configure do |config|
end
