lemmatizer
==========

Lemmatizer for text in English.  Inspired by Python's nltk.corpus.reader.wordnet.morphy package

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

