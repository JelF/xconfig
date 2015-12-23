require 'active_support/core_ext/string/inflections'

module XConfig
  # Implements Core#push
  # Basicly, it converts target to a Module (or Class) and apply config rules
  # (NYI), then safely merges it with global configuration
  class PushConfig
    attr_reader :target
    attr_accessor :global_config

    # @param target [Module, String, Symbol]
    #   module for which configuration would be done
    # @param values [Hash]
    #   configuration data
    # @param global_config [Hash]
    #   reference to Core#global_config
    def initialize(target, values, global_config)
      self.target = target
      self.global_config = global_config
      merge_values!(values)
    end

    # Sets `@target` ivar to converted value of x
    #   Conversion: (@see [spec/xconfig/push_config_spec] `#target=` section)
    #   - 'foo.bar' => `Foo::Bar`
    #   - 'foo/bar' => `Foo::Bar`
    #   - 'Foo::Bar' => `Foo::Bar`
    # @param x [Module, String, Symbol]
    #   module for which configuration would be done
    def target=(x)
      x = x.to_s if x.is_a?(Symbol)
      x = x.tr('.', '/').camelize.constantize if x.is_a?(String)

      unless x.is_a?(Module)
        fail ArgumentError, 'target should be either Symbol, String or Module'
      end

      @target = x
    end

    # recursivly merges module and it's submodules into global_config
    # @param values [Hash]
    #   configuration data
    # @return [Hash]
    #   new global_config
    def merge_values!(values)
      # STUB: should make recorsive calls if need
      global_config[target] ||= {}
      global_config[target].merge!(values)
    end
  end
end
