require 'yaml'

require 'xconfig/wrapper'
require 'xconfig/core'

module XConfig
  # Contains '::configure' logic
  module Writer
    def configure(hash = {})
      config = __xconfig_read_hash(hash)
      yield Wrapper.new(config) if block_given?
      Core.push(name, config)
    end

    private

    # @param hash [String|Pathname|Hash]
    # @return [Hash]
    #   stringified hash if [Hash] passed
    # @return [Hash]
    #   loaded from hash, used as path of YAML file, with stringified keys
    def __xconfig_read_hash(hash)
      case hash
      when String, Pathname
        YAML.load_file(hash.to_s)
      when Hash
        hash.deep_stringify_keys
      else
        fail ArgumentError, 'Specify either path or hash'
      end
    end
  end
end
