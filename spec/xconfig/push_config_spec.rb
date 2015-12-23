module Foo
  module Bar
    Baz = Class.new
  end
end

describe XConfig::PushConfig do
  let(:target) { 'foo' }
  let(:values) { { bar: :baz } }
  let(:global_config) { {} }
  subject { described_class.new(target, values, global_config) }

  describe '#target=' do
    matrix = [
      ['foo', Foo],
      ['Foo', Foo],
      [:foo, Foo],
      [Foo, Foo],
      ['foo/bar', Foo::Bar],
      ['foo.bar', Foo::Bar],
      ['Foo/Bar', Foo::Bar],
      [:'foo.bar', Foo::Bar],
      ['foo/bar.baz', Foo::Bar::Baz],
      ['foo.Bar/Baz', Foo::Bar::Baz],
      [Foo::Bar::Baz, Foo::Bar::Baz]
    ]

    matrix.each do |value, expectation|
      specify "#{value.inspect} => `#{expectation}`" do
        subject.target = value
        expect(subject.target).to eq(expectation)
      end
    end

    specify 'it raises error if unable to convert' do
      expect { subject.target = %i(foo bar baz) }
        .to raise_error(ArgumentError,
                        'target should be either Symbol, String or Module')
    end

    specify 'it raises error if target not defined' do
      expect { subject.target = 'foo/baz' }
        .to raise_error(NameError, /Foo::Baz/)
    end
  end

  describe '#merge_values!' do
    before { subject }

    context 'target present' do
      let(:global_config) { { Foo => { x: :y } } }

      specify 'it merged with existing config' do
        expect(global_config)
          .to match(Foo => match(bar: :baz, x: :y))
      end
    end

    specify 'it creates new config entry' do
      expect(global_config).to match(Foo => match(bar: :baz))
    end
  end
end
