
require 'yard'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

ROOT = Pathname.new(__FILE__).join('..')

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = Dir[ROOT.join('lib/**/*.rb')]
  t.options = %w(--private)
end

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task default: %i(rubocop spec:coverage)

def open_in_browser(path)
  require 'launchy'
  require 'uri'

  Launchy.open(URI.join('file:///', path.to_s))
end

namespace :spec do
  coverage_root = ROOT.join('spec/coverage')
  desc "writes simplecov coverage in #{coverage_root}"
  task coverage: %i(simplecov spec)

  desc 'sets up simplecov'
  task :simplecov do
    if RUBY_PLATFORM == 'java'
      puts 'simplecov fails with jruby and will not run'
    else
      ENV['COVERAGE_ROOT'] = coverage_root.to_s
    end
  end

  desc 'runs spec with coverage and opens result'
  task :show_coverage do
    begin
      Rake::Task['spec:coverage'].invoke
    rescue SystemExit
      puts 'specs failed or coverage too low!'
    end

    open_in_browser coverage_root.join('index.html')
  end
end

namespace :doc do
  desc 'open doc'
  task open: :doc do
    open_in_browser ROOT.join('doc/frames.html')
  end
end
