Dog = Ivo.new :name, :age do
  def speak
    "bark!"
  end
end

module Animals
  Dog = Ivo.new :name, :age do
    def speak
      "bark!"
    end
  end
end

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

[Dog, Animals::Dog].each do |dog_class|
  RSpec.describe dog_class do
    before do
      @dog = dog_class.new 'Fido', 5
    end

    it 'is immutable' do
      expect(@dog).to be_frozen
    end

    it 'has a name' do
      expect(@dog.name).to eq 'Fido'
    end

    it 'has an age' do
      expect(@dog.age).to eq 5
    end

    it 'can speak' do
      expect(@dog.speak).to eq 'bark!'
    end
  end
end
