# encoding: utf-8
# TODO: find zlib
require 'base64'

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
        # TODO: Change to zlib
        record[key] = Base64.decode64(record[key]) if record.has_key? key
      }
      record
    end

  end if defined?(Filter) # Support only >= v0.12
end
