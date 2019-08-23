# frozen_string_literal: true

require "ivo/version"
require 'ivo/value'

module Ivo
  extend self

  def new(*attrs, &block)
    instance_ruby = build_instance_ruby(attrs)
    class_ruby = build_class_ruby(attrs)

    Class.new do
      instance_eval(instance_ruby)
      class_eval(class_ruby)
      class_eval(&block) if block
    end
  end

  def value(*attrs)
    instance_ruby = build_instance_ruby(attrs)
    class_ruby = build_class_ruby(attrs)

    template = <<~RUBY
      module ClassMethods
        %{instance_ruby}
      end

      def self.included(klass)
        klass.extend(ClassMethods)
      end
    RUBY

    ruby = template % {instance_ruby: instance_ruby}

    Module.new do
      module_eval(ruby)
      module_eval(class_ruby)
    end
  end

  def call(attrs = nil)
    Value.new(attrs)
  end

  private

  def build_class_ruby(attrs)
    template = <<~RUBY
      def initialize(%{args})
        %{instance_variable_assignments}
        freeze
      end

      %{attr_reader_declaration}

      def ==(other)
        %{equality_check}
      end

      alias_method :eql?, :==

      %{hash_method}
    RUBY

    # a, b
    args = attrs.map { |attr| "#{attr} = nil" }.join(', ')

    # @a = a
    # @b = b
    instance_variable_assignments = attrs.map { |attr| "@#{attr} = #{attr}" }.join("\n")

    # attr_reader :a, :b
    if attrs.any?
      arg_symbols = attrs.map { |attr| ":#{attr}" }.join(', ')
      attr_reader_declaration = "attr_reader #{arg_symbols}"
    end

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

    template % {
      args: args,
      instance_variable_assignments: instance_variable_assignments,
      attr_reader_declaration: attr_reader_declaration,
      equality_check: equality_check,
      hash_method: hash_method,
    }
  end

  def build_instance_ruby(attrs)
    template = <<~RUBY
      def with(%{keyword_args})
        new(%{values})
      end
    RUBY

    # a: nil, b: nil
    keyword_args = attrs.map { |attr| "#{attr}: nil" }.join(', ')

    values = attrs.join(', ')

    template % {keyword_args: keyword_args, values: values}
  end
end
