require 'active_model'

module LinkedVocabs::Validators
  class AuthorityValidator < ActiveModel::Validator
    def validate(record)
      unless record.in_vocab?
        record.errors.add :base, "#{record.rdf_subject.to_s} is not a term in a controlled vocabulary #{record.class.vocabularies}" 
      end
    end
  end
end
