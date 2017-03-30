RSpec.describe Ivo do
  describe '.new' do
    it 'is a class' do
      expect(Ivo.new).to be_a Class
    end

    it 'creates immutable objects' do
      klass = Ivo.new
      expect(klass.new).to be_frozen
    end

    it 'has attributes' do
      instance = Ivo.new(:name).new 'Austin'
      expect(instance.name).to eq 'Austin'
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
end
