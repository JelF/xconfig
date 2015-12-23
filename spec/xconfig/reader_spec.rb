class DummyConfiguratedClass
  include XConfig
end

describe XConfig::Reader do
  before { XConfig::Core.push('dummy_configurated_class', foo: :bar) }

  shared_examples 'config' do
    it { is_expected.to match(foo: :bar) }
    it { is_expected.to be_frozen }
    it { is_expected.to include foo: :bar }
    it { is_expected.to include 'foo' => :bar }
    it('is deep frozen') { expect(subject['foo']).to be_frozen }
  end

  describe '::config' do
    subject { DummyConfiguratedClass.config }
    it_behaves_like 'config'
  end

  describe '#config' do
    subject { DummyConfiguratedClass.new.config }
    it_behaves_like 'config'
  end
end
