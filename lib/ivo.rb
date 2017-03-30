require "ivo/version"

module Ivo
  def self.new(*attrs, &block)
    # a: nil, b: nil
    keyword_args = attrs.map { |attr| "#{attr}: nil" }.join ', '

    # a, b
    args = attrs.map { |attr| "#{attr} = nil" }.join ', '

    # @a = a
    # @b = b
    instance_variable_assignments = attrs.map { |attr| "@#{attr} = #{attr}" }.join "\n"

    code = <<~RUBY
      def self.with(#{keyword_args})
        new #{attrs.join ', '}
      end

      def initialize(#{args})
        #{instance_variable_assignments}
        freeze
      end
    RUBY

    Class.new do
      class_eval code

      attr_reader *attrs

      class_eval &block if block
    end
  end
end
