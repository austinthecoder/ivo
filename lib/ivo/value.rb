# frozen_string_literal: true

module Ivo
  class Value
    def initialize(data = nil)
      @data = {}
      data.each { |k, v| @data[k.to_sym] = v } if data
      freeze
    end

    def respond_to_missing?(method_id, include_private = false)
      data.key?(method_id) || super
    end

    def method_missing(method_id, *args)
      data.fetch(method_id) { super }
    end

    def ==(other)
      self.class == other.class && data == other.data
    end

    alias_method :eql?, :==

    def hash
      data.hash
    end

    def inspect
      attributes = data.map { |key, value| "#{key}=#{value.inspect}" }.join(', ')
      "#<#{self.class.name} #{attributes}>"
    end

    protected

    attr_reader :data
  end
end
