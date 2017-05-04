# encoding: utf-8
require 'zlib'

require 'fluent/plugin/filter'

module Fluent
  class ZlibDecodeFilter < Filter
    Plugin.register_filter('zlib_decode', self)

    def initialize
      super
    end

    config_param :fields, :array, value_type: :string

    def configure(conf)
      super
    end

    def filter(tag, time, record)
      @fields.each { |key|
        record[key] = Zlib::Inflate.inflate(record[key]) if record.has_key? key
      }
      record
    end

  end if defined?(Filter) # Support only >= v0.12
end
