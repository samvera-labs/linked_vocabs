#!/usr/bin/env rake

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'linked_vocabs'

Bundler::GemHelper.install_tasks

desc "Generate Vocabularies"

task :gen_vocabs do
  LinkedVocabs.vocabularies.each_key do |name|
    puts "Generating vocabulary at lib/rdf/#{name}.rb"
    begin
      LinkedVocabs.load_vocabulary(name)
    rescue
      puts "Failed to load #{name}: #{$!.message}"
      puts $!.backtrace
    end
  end
end
