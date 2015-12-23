require 'pathname'

module ConfigurableModule
  extend XConfig
end

describe XConfig::Writer, :isolate_xconfig do
  subject { XConfig::Core.fetch(ConfigurableModule) }

  it 'accepts pathame' do
    path = Pathname.new(__FILE__).join('../../data/example_config.yml')
    ConfigurableModule.configure(path)

    expectation = YAML.load_file(path.to_s).deep_stringify_keys
    expect(subject).to match(expectation)
  end

  it 'accepts block' do
    ConfigurableModule.configure do |config|
      config.foo!
      config.bar = :baz if config.foo?
      config.baz = { a: :b }
    end

    expect(subject)
      .to match('foo' => true, 'bar' => :baz, 'baz' => { 'a' => :b })
  end

  it 'discards something strange' do
    expect { ConfigurableModule.configure(true) }
      .to raise_error(ArgumentError, 'Specify either path or hash')
  end

  pending 'it gets all related configs, i.e. set in submodules'
end
