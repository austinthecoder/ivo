class Dog
  include Ivo.value :name, :age

  def speak
    "bark!"
  end
end

dogs = [
  Dog.new('Fido', 5),
  Dog.new('Fido', 5),
  Dog.new('Spot', 5),
]

instant_dogs = [
  Ivo.(name: 'Fido', age: 5),
  Ivo.(name: 'Fido', age: 5),
  Ivo.(name: 'Spot', age: 5),
]

RSpec.describe Ivo do
  describe '.new' do
    it 'is a class' do
      expect(Dog).to be_a Class
    end
  end

  it 'can be instantiated with a hash' do
    instance = Ivo.new(:name).with name: 'Austin'
    expect(instance.name).to eq 'Austin'
  end

  it 'attributes default to nil' do
    instance = Ivo.new(:name).new
    expect(instance.name).to be_nil
  end
end

RSpec.describe Dog do
  it 'can be instantiated with a hash' do
    dog = Dog.with name: 'Austin'
    expect(dog.name).to eq 'Austin'
  end

  it 'is immutable' do
    expect(dogs[0]).to be_frozen
  end

  it 'has a name' do
    expect(dogs[0].name).to eq 'Fido'
  end

  it 'has an age' do
    expect(dogs[0].age).to eq 5
  end

  it 'can speak' do
    expect(dogs[0].speak).to eq 'bark!'
  end

  it 'is equal to the same dog' do
    expect(dogs[0]).to eq dogs[1]
  end

  it 'is not equal to a different dog' do
    expect(dogs[0]).to_not eq dogs[2]
  end
end

RSpec.describe 'Value' do
  it 'is immutable' do
    expect(instant_dogs[0]).to be_frozen
  end

  it 'has a name' do
    expect(instant_dogs[0].name).to eq 'Fido'
  end

  it 'has an age' do
    expect(instant_dogs[0].age).to eq 5
  end

  it 'is equal to the same dog' do
    expect(instant_dogs[0]).to eq instant_dogs[1]
  end

  it 'is not equal to a different dog' do
    expect(instant_dogs[0]).to_not eq instant_dogs[2]
  end
end
