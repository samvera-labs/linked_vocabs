require 'spec_helper'

describe LinkedVocabs::Validators::PropertyValidator do
  before do
    class DummyAuthority < ActiveTriples::Resource
      include LinkedVocabs::Controlled
      use_vocabulary :dcmitype

      property :type, :predicate => RDF::DC.type, :class_name => DummyAuthority
    end

    class DummyResource < ActiveTriples::Resource
      validates_vocabulary_of :type

      property :type, :predicate => RDF::DC.type, :class_name => DummyAuthority
    end
  end

  after do
    Object.send(:remove_const, 'DummyAuthority') if Object
    Object.send(:remove_const, 'DummyResource') if Object
  end
  
  subject { DummyResource.new }
  let(:authority) { DummyAuthority }
  
  context 'with value in vocabulary' do
    before do
      subject.type = authority.list_terms.first
    end
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is invalid with other invalid values' do
      subject.type << 'freetext value'
      expect(subject).not_to be_valid
    end
  end

  context 'with value out of vocabulary' do
    before do
      subject.type = authority.new
    end
    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with value of wrong class' do
    before do
      class NotAuthority < ActiveTriples::Resource; end
      subject.type = NotAuthority.new
    end

    after do
      Object.send(:remove_const, 'NotAuthority') if Object
    end

    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with literal value' do
    before do
      subject.type = 'freetext value'
    end
    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

end
