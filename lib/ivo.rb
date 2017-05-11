require "ivo/version"
require 'ivo/value'

module Ivo
  def self.new(*attrs, &block)
    Class.new do
      include Ivo.value *attrs

      class_eval &block if block
    end
  end

  def self.value(*attrs)
    # a: nil, b: nil
    keyword_args = attrs.map { |attr| "#{attr}: nil" }.join ', '

    # a, b
    args = attrs.map { |attr| "#{attr} = nil" }.join ', '

    # @a = a
    # @b = b
    instance_variable_assignments = attrs.map { |attr| "@#{attr} = #{attr}" }.join "\n"

    equality_check = begin
      checks = ['self.class == other.class']
      attrs.each { |attr| checks << "#{attr} == other.#{attr}" }
      checks.join ' && '
    end

    hash = attrs.map { |attr| "#{attr}.hash" }.join ' ^ '

    code = <<~RUBY
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def with(#{keyword_args})
          new #{attrs.join ', '}
        end
      end

      def initialize(#{args})
        #{instance_variable_assignments}
        freeze
      end

      def ==(other)
        #{equality_check}
      end

      def hash
        #{hash}
      end
    RUBY

    Module.new do
      module_eval code

      attr_reader *attrs

      def eql?(other)
        self == other
      end
    end
  end

  def self.call(attrs = nil)
    Value.new attrs
  end
end
