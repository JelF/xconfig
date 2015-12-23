require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash/indifferent_access'
require 'activesupport/lib/active_support/core_ext/object/deep_dup'
require 'singleton'
require 'ice_nine'
require 'memoist'

require 'xconfig/push_config'

module XConfig
  # Core object is a singleton storing configuration
  class Core
    extend Memoist
    include Singleton

    class << self
      delegate :fetch, :[], :push, to: :instance
    end

    delegate :deep_freeze, to: IceNine

    # Sets global_config to empty hash
    def initialize
      self.global_config = {}
    end

    # Delegates to global_config, than deep freezes it with indifferent access
    # @return [ActiveSupport::HashWithIndifferentAccess]
    #   related config if exist
    # @raise [KeyError]
    #   if config does not exist and no fallback provided
    def fetch(*args, &block)
      if args.length > 1
        target, fallback = *args
      else
        target = args[0]
        fallback = block ? block.call : :fetch_failed
      end

      result = __fetch(target)
      result = fallback if result == :fetch_failed
      fail KeyError, "Key #{target} not found" if result == :fetch_failed
      result
    end

    # Delegates to global_config, then deep freezes it with indifferent access
    # @return [ActiveSupport::HashWithIndifferentAccess]
    #   related config if exist
    # @return [ActiveSupport::HashWithIndifferentAccess]
    #   {} if config does not exist
    def [](x)
      fetch(x, HashWithIndifferentAccess.new)
    end

    # Merges values into config with key 'target'
    # @param target [String, Symbol, Module]
    #   @see [spec/xconfig/push_config_spec] `#target=` section
    # @param values [Hash] data
    # @return [ActiveSupport::HashWithIndifferentAccess]
    #   new config value for target
    def push(target, values)
      processor = PushConfig.new(target, values, global_config)
      flush_cache
      fetch(processor.target)
    end

    private

    # memoized part of fetch method
    # @param target [Module]
    #   module to fetch from global_config
    # @return [ActiveSupport::HashWithIndifferentAccess]
    #   frozen config if exist
    # @return [Symbol]
    #   `:fetch_failed` if config does not exist
    def __fetch(target)
      deep_freeze(global_config.fetch(target).with_indifferent_access)
    rescue KeyError
      # using fetch_failed instead of error raising to memoise result
      :fetch_failed
    end
    memoize :__fetch

    attr_accessor :global_config
  end
end
