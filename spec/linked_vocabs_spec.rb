require 'spec_helper'

describe LinkedVocabs do
  describe '#vocabularies' do
    it 'should have be a hash' do
      expect(LinkedVocabs.vocabularies).to be_a Hash
    end
  
    it 'should have prefixes' do
      LinkedVocabs.vocabularies.each_pair do |vocab, config|
        expect(config).to have_key :prefix
      end
    end
  end
  
  describe '#add_vocabulary' do
    before do
      LinkedVocabs.add_vocabulary('aat', 'http://vocab.getty.edu/aat/', :strict => false, :fetch => false)
    end

    it 'should register a vocabulary' do
      expect(LinkedVocabs.vocabularies).to have_key :aat
    end

    context 'with no source url given' do
      before do
        LinkedVocabs.add_vocabulary('lcsh', 'http://id.loc.gov/authorities/subjects/')
      end

      it 'should set strict to false ' do
        expect(LinkedVocabs.vocabularies[:lcsh][:strict]).to eq false
      end
      it 'should set fetch to false ' do
        expect(LinkedVocabs.vocabularies[:lcsh][:fetch]).to eq false
      end
    end
  end
end
