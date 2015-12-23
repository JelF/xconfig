require 'xconfig/core'
require 'active_support/core_ext/module/delegation'

module XConfig
  # This module would actualy been extended in case you `include XConfig`.
  # It defines ::config and #config readers
  module Reader
    # Delegates `#config` to `::config`
    def self.extended(base)
      base.send(:delegate, :config, to: base)
    end

    # Fetches config from XConfig::Core singleton. It is already cached there
    # @return [ActiveSupport::HashWithIndifferentAccess]
    #   configuration hash, which is deep_frozen
    def config
      XConfig::Core.fetch(self)
    end
  end
end
