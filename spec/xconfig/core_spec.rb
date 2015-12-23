module Foo
  Bar = Module.new
end

describe XConfig::Core, :isolate_xconfig do
  subject { described_class }

  let(:global_config) { { Foo => { bar: :baz } } }

  describe '#fetch' do
    specify 'config exists' do
      expect(subject.fetch(Foo, {})).to match(bar: :baz)
      expect(subject.fetch(Foo, {})).to be_frozen
      expect(subject.fetch(Foo, {}))
        .to be_a ActiveSupport::HashWithIndifferentAccess
    end

    specify 'config dose not exist' do
      expect { subject.fetch(Foo::Bar) }.to raise_error(KeyError, /Foo::Bar/)
      expect(subject.fetch(Foo::Bar, {})).to eq({})
      expect(subject.fetch(Foo::Bar) { {} }).to eq({})
    end
  end

  describe '#[]' do
    specify 'config exists' do
      expect(subject[Foo]).to match(bar: :baz)
      expect(subject[Foo]).to be_frozen
      expect(subject[Foo]).to be_a ActiveSupport::HashWithIndifferentAccess
    end

    specify 'config does not exist' do
      expect(subject[Foo::Bar]).to eq({})
    end
  end

  specify '#push' do
    expect(subject[Foo::Bar]).to eq({})
    subject.push('foo/bar', baz: :foo)
    expect(subject[Foo::Bar]).to match(baz: :foo)
  end
end
