#!/usr/bin/env ruby

require 'bundler/inline'

require 'benchmark'
require 'ostruct'

gemfile do
  source 'https://rubygems.org'

  gem 'ivo', '~> 0.4'
  gem 'immutable-struct', '~> 2.4'
  gem 'values', '~> 1.8'
end

StructClass = Struct.new(:x, :y)
ImmutableStructClass = ImmutableStruct.new(:x, :y)
ValueClass = Value.new(:x, :y)
IvoClass = Ivo.new(:x, :y)

n = 1_000_000

Benchmark.bm(30) do |x|
  x.report('StructClass.new') do
    n.times do
      StructClass.new(1, 2)
    end
  end

  x.report('IvoClass.new') do
    n.times do
      IvoClass.new(1, 2)
    end
  end

  x.report('IvoClass.with') do
    n.times do
      IvoClass.with(x: 1, y: 2)
    end
  end

  x.report('ValueClass.new') do
    n.times do
      ValueClass.new(1, 2)
    end
  end

  x.report('ValueClass.with') do
    n.times do
      ValueClass.with(x: 1, y: 2)
    end
  end

  x.report('ImmutableStructClass.new') do
    n.times do
      ImmutableStructClass.new(x: 1, y: 2)
    end
  end
end

Benchmark.bm(30) do |x|
  x.report('OpenStruct.new') do
    n.times do
      OpenStruct.new(x: 1, y: 2)
    end
  end

  x.report('Ivo.call') do
    n.times do
      Ivo.call(x: 1, y: 2)
    end
  end
end
