shared_context 'with isolated xconfig', isolate_xconfig: true do
  let(:global_config) { {} }
  around do |example|
    old_config = XConfig::Core.instance.send(:global_config).deep_dup
    XConfig::Core.instance.send(:global_config=, global_config)
    example.run
    XConfig::Core.instance.send(:global_config=, old_config)
    XConfig::Core.instance.flush_cache
  end
end
