$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'xconfig/version'

Gem::Specification.new do |spec|
  spec.name = 'xconfig'
  spec.version = XConfig::VERSION
  spec.authors = %w(jelf)
  spec.summary = 'XConfig is a ruby gem configuration engine'
  spec.description = <<-MARKDOWN.gsub('\s{4}', '')
    # XConfig
    XConfig is a ruby gem configuration engine
    Visit [https://github.com/JelF/xconfig/blob/#{XConfig::VERSION}/README.md]
    for documentation
    Documentation at master: [https://github.com/JelF/xconfig/README.md]
  MARKDOWN


  if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
    spec.platform = 'java'
  else
    spec.required_ruby_version = '~> 2.1'
  end

  spec.homepage = 'https://github.com/JelF/xconfig'
  spec.license = 'WTFPL'

  spec.email = %W(begdory4+#{spec.name}@gmail.com)
  spec.files = `git ls-files -z`.split("\x0").grep(%r{\Alib/.+\.rb\z})

  spec.require_paths = %w(lib)

  spec.add_dependency 'activesupport', '~> 4.0'
  spec.add_dependency 'ice_nine', '~> 0.11'
  spec.add_dependency 'memoist', '~> 0.11'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rubocop', '~> 0.35'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'simplecov', '~> 0.11'
  spec.add_development_dependency 'launchy', '~> 2.4'
end
