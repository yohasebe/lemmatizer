lemmatizer
==========

Lemmatizer for text in English.  Inspired by Python's [nltk.corpus.reader.wordnet.morphy](orpusReader.morphy) package.

Based on code posted by mtbr at his blog entry [WordNet-based lemmatizer](http://d.hatena.ne.jp/mtbr/20090303/prfrnlprubyWordNetbasedlemmatizer)

Installation
------------

    sudo gem install lemmatizer
    

Usage
-----

    require "lemmatizer"
    
    lem = Lemmatizer.new
    
    p lem.lemma("dogs",    :noun ) # => "dog"
    p lem.lemma("hired",   :verb ) # => "hire"
    p lem.lemma("hotter",  :adj  ) # => "hot"
    p lem.lemma("better",  :adv  ) # => "well"

    # Lemmatizer leaves alone words that its dictionary does not contain.  This keeps proper names such as "James" intact.
    p lem.lemma("MacBooks", :noun) # => "MacBooks" 

