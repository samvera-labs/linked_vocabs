#!/usr/bin/env rake

require 'linked_vocabs'

desc "Generate Vocabularies"

task :gen_vocabs do
  LinkedVocabs.vocabularies.each_key do |name|
    puts "Generating vocabulary at lib/linked_vocabs/vocabularies/#{name}.rb"
    begin
      LinkedVocabs.load_vocabulary(name)
    rescue
      puts "Failed to load #{name}: #{$!.message}"
    end
  end
end
