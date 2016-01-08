require 'active_model'

module LinkedVocabs::Validators
  class PropertyValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, values)
      values.each do |v|
        unless v.try(:in_vocab?)
          term = v.try(:rdf_subject) || v
          vocabularies = record.class.properties[attribute.to_s].class_name.vocabularies.keys
          if term.is_a? RDF::URI
            record.errors.add :base, "value `#{term}' for `#{attribute}' property is not a term in a controlled vocabulary #{vocabularies.join(', ')}"
          else
            record.errors.add :base, "`#{term}' for `#{attribute}' property is expected to be a URI, but it is a #{term.class}"
          end
        end
      end
    end
  end
end

module ActiveModel::Validations::HelperMethods
  def validates_vocabulary_of(*attr_names)
    validates_with LinkedVocabs::Validators::PropertyValidator, :attributes => attr_names
  end
end
