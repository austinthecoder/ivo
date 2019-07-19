# frozen_string_literal: true

require "ivo/version"
require 'ivo/value'

module Ivo
  extend self

  def new(*attrs, &block)
    Class.new do
      include Ivo.value(*attrs)

      class_eval(&block) if block
    end
  end

  def value(*attrs)
    code_template = <<~RUBY
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def with(%{keyword_args})
          new(%{values})
        end
      end

      %{attr_reader_declaration}

      def initialize(%{args})
        %{instance_variable_assignments}
        freeze
      end

      def ==(other)
        %{equality_check}
      end

      def eql?(other)
        self == other
      end

      %{hash_method}
    RUBY

    # a: nil, b: nil
    keyword_args = attrs.map { |attr| "#{attr}: nil" }.join(', ')

    # a, b
    args = attrs.map { |attr| "#{attr} = nil" }.join(', ')

    # attr_reader :a, :b
    if attrs.any?
      arg_symbols = attrs.map { |attr| ":#{attr}" }.join(', ')
      attr_reader_declaration = "attr_reader #{arg_symbols}"
    end

    # @a = a
    # @b = b
    instance_variable_assignments = attrs.map { |attr| "@#{attr} = #{attr}" }.join("\n")

    # self.class == other.class && a == other.a && b == other.b
    equality_check = begin
      checks = ['self.class == other.class']
      attrs.each { |attr| checks << "#{attr} == other.#{attr}" }
      checks.join(' && ')
    end

    # def hash
    #   a.hash ^ b.hash
    # end
    if attrs.any?
      hash = attrs.map { |attr| "#{attr}.hash" }.join(' ^ ')
      hash_method = <<~RUBY
        def hash
          #{hash}
        end
      RUBY
    end

    code = code_template % {
      keyword_args: keyword_args,
      values: attrs.join(', '),
      args: args,
      attr_reader_declaration: attr_reader_declaration,
      instance_variable_assignments: instance_variable_assignments,
      equality_check: equality_check,
      hash_method: hash_method,
    }

    Module.new do
      module_eval(code)
    end
  end

  def call(attrs = nil)
    Value.new(attrs)
  end
end
