# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'lemmatizer/version'

Gem::Specification.new do |gem|
  gem.name          = 'lemmatizer'
  gem.version       = Lemmatizer::VERSION
  gem.authors       = ['Yoichiro Hasebe']
  gem.email         = ['yohasebe@gmail.com']
  gem.description   = %q(
    Lemmatizer for text in English. Inspired by Python's nltk.corpus.reader.wordnet.morphy package.
  )
  gem.summary       = 'Englsh lemmatizer in Ruby'
  gem.homepage      = 'http://github.com/yohasebe/lemmatizer'
  gem.licenses      = ['MIT']
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r(^bin/)).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r(^(test|spec|features)/))
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec'
end
