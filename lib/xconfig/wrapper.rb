require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

module XConfig
  # Defines Config wrapper which allows easier access to cofig hash,
  # which behaves like usual
  class Wrapper
    # @param config [Hash]
    def initialize(config = {})
      @config = config
      @model = {}
    end

    def method_missing(name, *args)
      name = name.to_s

      case name
      when /\=\z/
        __write(name[0...-1], *args)
      when /!\z/
        __write(name[0...-1], true)
      when /\?\z/
        value = __read(name[0...-1], *args)
        return false if value.try(:__xquery_config).try!(:blank?)
        value.present?
      else
        __read(name, *args)
      end
    end

    # Compares entire config
    # @param other [Hash]
    # @return [Boolean]
    def eql?(other)
      @config.eql?(other.deep_stringify_keys)
    end

    # Internal API reader
    # @return [Hash] `@config`
    def __xquery_config
      @config
    end

    private

    # Writes to config and flushes cache
    # @param name [String]
    # @param value [Object]
    # @return [Object] value
    def __write(name, value)
      @model.delete(name)

      if value.respond_to?(:deep_stringify_keys)
        value = value.deep_stringify_keys
      end

      @config[name] = value
    end

    # Reads from config and caches result
    # @param name [String]
    # @return [XConfig::Wrapper] if hash found
    # @return [Object] unless hash found
    def __read(name)
      @model.fetch(name) do
        object = (@config[name] ||= {})
        @model[name] = object.is_a?(Hash) ? Wrapper.new(object) : object
      end
    end
  end
end
