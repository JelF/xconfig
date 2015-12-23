describe XConfig::Wrapper do
  subject { described_class.new({}) }

  def be_wrapped
    be_a described_class
  end

  it 'wraps unset keys as {}' do
    expect(subject.foo).to be_wrapped
    expect(subject.foo).to eql({})
  end

  describe 'setters' do
    it 'allows to set data' do
      expect(subject.foo = :bar).to eq :bar
      expect(subject.foo).to eq :bar
    end

    it 'resets cache after setting new value' do
      subject.foo = { bar: :baz }
      expect(subject.foo).to eql bar: :baz
      subject.foo!
      expect(subject.foo).not_to be_wrapped
      expect(subject.foo).to eq true
    end

    it 'saves result config untainted' do
      subject.foo!
      subject.bar.baz = 123
      expect(subject.__xquery_config)
        .to match 'foo' => true, 'bar' => { 'baz' => 123 }
    end
  end

  describe 'getters' do
    it 'wraps hashes' do
      subject.foo = { bar: :baz }
      expect(subject.foo).to be_wrapped
      expect(subject.foo.bar).to eq :baz
    end

    it 'returns other values' do
      subject.foo = 123
      expect(subject.foo).not_to be_wrapped
      expect(subject.foo).to eq 123
    end
  end

  describe 'bangs' do
    it 'responds to banged methods' do
      expect(subject.foo!).to eq true
      expect(subject.foo).to eq true
    end
  end

  describe 'predicates' do
    it 'responds to predicates' do
      subject.foo = { bar: :baz }
      expect(subject.foo?).to eq true
    end

    it 'returns false if key unset' do
      expect(subject.foo?).to eq false
    end

    it 'uses presence' do
      subject.foo = ''
      expect(subject.foo?).to eq false
    end

    it 'uses presence on wrapped config' do
      subject.foo = {}
      expect(subject.foo?).to eq false
    end
  end
end
