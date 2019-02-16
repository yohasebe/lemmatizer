lemmatizer
==========
Lemmatizer for text in English.  Inspired by Python's [nltk.corpus.reader.wordnet.morphy](orpusReader.morphy) package.

Based on code posted by mtbr at his blog entry [WordNet-based lemmatizer](http://d.hatena.ne.jp/mtbr/20090303/prfrnlprubyWordNetbasedlemmatizer)

Version 0.2 has added functionality to add user supplied data at runtime 

Installation
------------
    sudo gem install lemmatizer
    

Usage
-----
```ruby
require "lemmatizer"
  
lem = Lemmatizer.new
  
p lem.lemma("dogs",    :noun ) # => "dog"
p lem.lemma("hired",   :verb ) # => "hire"
p lem.lemma("hotter",  :adj  ) # => "hot"
p lem.lemma("better",  :adv  ) # => "well"
  
# when part-of-speech symbol is not specified as the second argument, 
# lemmatizer tries :verb, :noun, :adj, and :adv one by one in this order.
p lem.lemma("fired")           # => "fire"
p lem.lemma("slow")            # => "slow"
```

Limitations
-----------
```ruby
# Lemmatizer leaves alone words that its dictionary does not contain.
# This keeps proper names such as "James" intact.
p lem.lemma("MacBooks", :noun) # => "MacBooks" 
  
# If an inflected form is included as a lemma in the word index,
# lemmatizer may not give an expected result.
p lem.lemma("higher", :adj) # => "higher" not "high"!

# The above has to happen because "higher" is itself an entry word listed in dict/index.adj .
# To fix this, modify the original dict directly (lib/dict/index.{noun|verb|adj|adv}) 
# or supply with custom dict files (recommended).
```

Supplying with user dict
-----------
```ruby
# You can supply custom dict files consisting of lines in the format of <pos>\s+<form>\s+<lemma>.
# The data in user supplied files overrides the preset data. Here's the sample. 

# --- sample.dict.txt (don't include hash symbol on the left) ---
# adj   higher   high
# adj   highest  high
# noun  MacBooks MacBook
# ---------------------------------------------------------------

lem = Lemmatizer.new("sample.dict.txt")
# => 3 lexical items added from dict file provided

p lem.lemma("higher", :adj)     # => "high"
p lem.lemma("highest", :adj)    # => "high"
p lem.lemma("MacBooks", :noun)  # => "MacBook"

# The argument to Lemmatizer.new can be either of the following:
# 1) a path string to a dict file (e.g. "/path/to/dict.txt")
# 2) an array of paths to dict files (e.g. ["./dict/noun.txt", "./dict/verb.txt"])

```

Author
------
* Yoichiro Hasebe <yohasebe@gmail.com>

Thanks for assistance and contributions:
* Vladimir Ivic <http://vladimirivic.com>

License
-------
Licensed under the MIT license.
