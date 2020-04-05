# Ivo

A library for creating immutable value objects.

## Installation

`gem install ivo`

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
