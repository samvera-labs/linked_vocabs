require 'active_fedora'

require 'linked_vocabs/version'
require 'linked_vocabs/controlled'

module LinkedVocabs
  
  @vocabularies = {
    :dcmitype       => { :prefix => 'http://purl.org/dc/dcmitype/', :source => 'http://dublincore.org/2012/06/14/dctype.rdf' },
    :iso_639_1      =>  { :prefix => 'http://id.loc.gov/vocabulary/iso639-1/', :source => 'http://id.loc.gov/vocabulary/iso639-1.nt'},
    :iso_639_2      =>  { :prefix => 'http://id.loc.gov/vocabulary/iso639-2/', :source => 'http://id.loc.gov/vocabulary/iso639-2.nt'},
    :marc_lang      =>  { :prefix => 'http://id.loc.gov/vocabulary/languages/', :source => 'http://id.loc.gov/vocabulary/languages.nt'},
    :geonames       =>  { :prefix => 'http://sws.geonames.org/', :strict => false, :fetch => false },
    :lcsh           =>  { :prefix => 'http://id.loc.gov/authorities/subjects/', :strict => false, :fetch => false },
    :aat            =>  { :prefix => 'http://vocab.getty.edu/aat/', :strict => false, :fetch => false }
  }
  
  def vocabularies
    @vocabularies
  end
  module_function :vocabularies

  def add_vocabulary(name, prefix, args = {})
    name = name.to_sym
    source = args.delete :source
    strict = args.delete :strict
    fetch = args.delete :fetch
    raise "Unexpected arguments #{args.keys}. Accepted parameters are :source, :strict, and :fetch." unless args.empty?
    @vocabularies[name] = { 
      :prefix => prefix.to_s,
      :strict => strict,
      :fetch => fetch
    }
    @vocabularies[name][:source] = source if source
    @vocabularies[name][:strict] = false if vocabularies[name][:strict].nil? or !source
    @vocabularies[name][:fetch] = false if vocabularies[name][:fetch].nil? or !source
  end
  module_function :add_vocabulary
end
