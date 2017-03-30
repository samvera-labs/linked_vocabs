require 'active_triples'
require 'active_model'

require 'rdf/vocab'
Dir['./lib/rdf/vocab/*.rb'].each { |f| require f }

require 'linked_vocabs/version'
require 'linked_vocabs/validators'
require 'linked_vocabs/controlled'

module LinkedVocabs
  def vocabularies
    @vocabularies ||= {
      :dcmitype => { :prefix => 'http://purl.org/dc/dcmitype/', :source => 'http://dublincore.org/2012/06/14/dctype.rdf' },
      :geonames => { :prefix => 'http://sws.geonames.org/', :strict => false, :fetch => false },
      :lcsh     => { :prefix => 'http://id.loc.gov/authorities/subjects/', :strict => false, :fetch => false }
    }
  end
  module_function :vocabularies

  def add_vocabulary(name, prefix, args = {})
    name = name.to_sym
    source = args.delete :source
    strict = args.delete :strict
    fetch = args.delete :fetch
    raise "Unexpected arguments #{args.keys}. Accepted parameters are :source, :strict, and :fetch." unless args.empty?
    vocabularies[name] = {
      :prefix => prefix.to_s,
      :strict => strict,
      :fetch => fetch
    }
    vocabularies[name][:source] = source if source
    vocabularies[name][:strict] = false if vocabularies[name][:strict].nil? or !source
    vocabularies[name][:fetch] = false if vocabularies[name][:fetch].nil? or !source
  end
  module_function :add_vocabulary

  # Based closely on https://github.com/ruby-rdf/rdf/blob/47b2774285ad69bed2f92d42a386dda354d7282b/Rakefile#L73-L84
  def load_vocabulary(name, path = 'lib/rdf/vocab')
    raise "Unregistered vocabulary #{name}" unless vocabularies.has_key? name
    v = vocabularies[name]
    class_name = name.to_s.upcase
    if v.fetch(:fetch, true)
      cmd = "#{Gem.bin_path('rdf', 'rdf')} serialize --uri '#{v[:prefix]}' --output-format vocabulary"
      cmd += " --class-name #{class_name}"
      cmd += " -o lib/rdf/vocab/#{name}.rb_t"
      cmd += " --strict" if v.fetch(:strict, true)
      cmd += " '" + v.fetch(:source, v[:prefix]) + "'"
      puts "  #{cmd}"

      begin
        `#{cmd} && mv #{path}/#{name}.rb_t #{path}/#{name}.rb`
      rescue
        `rm -f #{path}/#{name}.rb_t`
        puts "Failed to load #{name}: #{$!.message}"
      end
    else
      out = StringIO.new
      out.print %(# -*- encoding: utf-8 -*-
        # This file generated automatically using vocab-fetch from #{v.fetch(:source, v[:prefix])}
        require 'rdf'
        module RDF
          class #{class_name} < RDF::#{"Strict" if v.fetch(:strict, true)}Vocabulary("#{v[:prefix]}")
            # terms not fetched by vocab-fetch
          end
        end
        ).gsub(/^        /, '')
      out.rewind
      File.open(File.join(path, "#{name}.rb"), "w") {|f| f.write out.read}
    end
  end
  module_function :load_vocabulary

  def load_all
    vocabularies.each_key do |name|
      load_vocabulary(name)
    end
  end
  module_function :load_all
end
