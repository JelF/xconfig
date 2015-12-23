require 'pry'

# This will check if i required all `activerecord/core_ext`s i need
require 'active_support/all' unless ENV['TRAVIS']

if ENV['COVERAGE_ROOT']
  require 'simplecov'

  SimpleCov.start do
    minimum_coverage 100
    coverage_dir ENV['COVERAGE_ROOT']
    add_group 'Library', 'lib'
    add_filter 'spec/'
  end
end

require 'xconfig'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each(&method(:require))

RSpec.configure do |config|
end
