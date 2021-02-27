# Ivo

[![Build Status](https://travis-ci.com/austinthecoder/ivo.svg?branch=master)](https://travis-ci.com/austinthecoder/ivo)

A library for creating immutable value objects.

## Installation

`gem install ivo`

## Benchmarks

See `benchmarks.rb`. Performed on ruby 2.7.1.

* [immutable-struct](https://rubygems.org/gems/immutable-struct)
* [values](https://rubygems.org/gems/values)
* [concurrent-ruby](https://rubygems.org/gems/concurrent-ruby)
* struct (core)
* ostruct (core)

```sh
                                     user     system      total        real
StructClass.new                  0.197386   0.000671   0.198057 (  0.199379)
IvoClass.new                     0.217936   0.000635   0.218571 (  0.219348)
IvoClass.with                    0.246758   0.000268   0.247026 (  0.247232)
ConcurrentImmutableStruct.new    0.782822   0.000924   0.783746 (  0.784684)
ValueClass.new                   1.365290   0.001162   1.366452 (  1.368131)
ValueClass.with                  1.990921   0.001786   1.992707 (  1.994895)
ImmutableStructClass.new         1.939959   0.001735   1.941694 (  1.943927)
                                     user     system      total        real
OpenStruct.new                   0.542196   0.000978   0.543174 (  0.544024)
Ivo.call                         0.592088   0.001324   0.593412 (  0.595383)
```

## Usage

```ruby
Car = Ivo.new(:make, :model)

car = Car.new('Honda', 'Accord')

car.make    # "Honda"
car.model   # "Accord"
car.frozen? # true
```

Objects can also be instantiated with keywords:

```ruby
car = Car.with(make: 'Honda', model: 'Accord')
```

`Ivo.new` also accepts a block for additional definitions:

```ruby
Car = Ivo.new(:make, :model) do
  def to_s
    "#{make} #{model}"
  end
end
```

For one-off value objects (similar to OpenStruct):

```ruby
car = Ivo.(make: 'Honda', model: 'Accord')

car.make    # "Honda"
car.model   # "Accord"
car.frozen? # true
```

## Under the hood

This:

```ruby
Car = Ivo.new(:make, :model) do
  def to_s
    "#{make} #{model}"
  end
end
```

is equivalent to:

```ruby
class Car
  def self.with(make: nil, model: nil)
    new(make, model)
  end

  def initialize(make = nil, model = nil)
    @make = make
    @model = model
    freeze
  end

  attr_reader :make, :model

  def to_s
    "#{make} #{model}"
  end

  def ==(other)
    self.class == other.class && make == other.make && model == other.model
  end

  alias_method :eql?, :==

  def hash
    make.hash ^ model.hash
  end
end
```
