require 'stringio'
require 'lemmatizer/version'
require 'lemmatizer/core_ext'
require 'lemmatizer/lemmatizer'

module Lemmatizer
  def self.new(dict = nil)
    Lemmatizer.new(dict)
  end
end
