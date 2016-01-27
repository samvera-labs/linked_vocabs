# Linked Vocabularies

Linked Data Controlled Vocabularies for ActiveFedora::Rdf

## Installation

Add this line to your application's Gemfile:

    gem 'linked_vocabs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install linked_vocabs

## Usage
```ruby

module Vocabularies
  class ISO_639_2 < ::RDF::StrictVocabulary("http://id.loc.gov/vocabulary/iso639-2/")

    # Concept terms
    property :abk, :label => 'Abkhazian'
    property :ace, :label => 'Achinese'
    property :ach, :label => 'Acoli'
    property :ada, :label => 'Adangme'
    property :ady, :label => 'Adyghe | Adygei'
    property :aar, :label => 'Afar'
    property :afh, :label => 'Afrihili'
    property :afr, :label => 'Afrikaans'
    # ...
  end
end

module ControlledVocabularies
  class Language < ActiveTriples::Resource
    include LinkedVocabs::Controlled

    use_vocabulary :iso_639_2, class: Vocabularies::ISO_639_2
  end
end

class DummyResource < ActiveTriples::Resource
  validates_vocabulary_of :language
  
  property :language, predicate: RDF::Vocab::DC.language,
                      class_name: ControlledVocabularies::Language

end

resource = DummyResource.new
resource.language = 'English'
resource.valid?
=> false
resource.errors.messages
=> {:base=>["`English' for `language' property is expected to be a URI, but it is a String"]}
resource.language = Vocabularies::ISO_639_2.afr
=> #<RDF::Vocabulary::Term:0x3febc9631bdc URI:http://id.loc.gov/vocabulary/iso639-2/afr>
resource.valid?
=> true
```    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
