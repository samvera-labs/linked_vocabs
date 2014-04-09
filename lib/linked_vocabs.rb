require 'active_fedora'

require 'linked_vocabs/version'
require 'linked_vocabs/controlled'
require 'linked_vocabs/vocabulary_loader'

module LinkedVocabs
  
  @vocabularies = {
    :dcmitype       => { :prefix => 'http://purl.org/dc/dcmitype/', :source => 'http://dublincore.org/2012/06/14/dctype.rdf' },
    :iso_639_2      =>  { :prefix => 'http://id.loc.gov/vocabulary/iso639-2/', :source => 'http://id.loc.gov/vocabulary/iso639-2.nt'},
    :geonames       =>  { :prefix => 'http://sws.geonames.org/', :strict => false, :fetch => false },
    :lcsh           =>  { :prefix => 'http://id.loc.gov/authorities/subjects/', :strict => false, :fetch => false },
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

  # Based closely on https://github.com/ruby-rdf/rdf/blob/develop/Rakefile 
  def load_vocabulary(name, path = 'lib/vocabularies/')
    raise "Unregistered vocabulary #{name}" unless vocabularies.has_key? name
    v = vocabularies[name]
    out = StringIO.new
    loader = LinkedVocabs::VocabularyLoader.new(name.to_s.upcase)
    loader.prefix = v[:prefix]
    loader.source = v[:source] if v[:source]
    loader.extra = v[:extra] if v[:extra]
    loader.fetch = v.fetch(:fetch, true)
    loader.strict = v.fetch(:strict, true)
    loader.output = out
    loader.run
    out.rewind
    File.open(File.join(path, "#{name}.rb"), "w") {|f| f.write out.read}
  end
  module_function :load_vocabulary
  
  def load_all
    vocabularies.each_key do |name|
      load_vocabulary(name)
    end
  end
  module_function :load_all
end
