require 'xconfig/writer'
require 'xconfig/reader'

# XConfig is a ruby gem configuration engine
module XConfig
  # actualy extends XConfig::Reader, defining '::config' and '#config'
  def self.included(base)
    base.extend(XConfig::Reader)
  end

  # actualy extend XConfig::Writer, defining '::configure'
  def self.extended(base)
    base.extend(XConfig::Writer)
  end
end
