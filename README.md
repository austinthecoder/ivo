# Ivo

A library for creating immutable value objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ivo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ivo

## Usage

### Basics

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

For one-off value objects:

```ruby
car = Ivo.(make: 'Honda', model: 'Accord')

car.make    # "Honda"
car.model   # "Accord"
car.frozen? # true
```

### Under the hood

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/austinthecoder/ivo.
