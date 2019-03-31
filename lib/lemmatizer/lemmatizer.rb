module Lemmatizer
  class Lemmatizer
    DATA_DIR = File.expand_path('..', File.dirname(__FILE__))

    WN_FILES = {
      :noun => [
        DATA_DIR + '/dict/index.noun',
        DATA_DIR + '/dict/noun.exc'
      ],
      :verb => [
        DATA_DIR + '/dict/index.verb',
        DATA_DIR + '/dict/verb.exc'
      ],
      :adj  => [
        DATA_DIR + '/dict/index.adj',
        DATA_DIR + '/dict/adj.exc'
      ],
      :adv  => [
        DATA_DIR + '/dict/index.adv',
        DATA_DIR + '/dict/adv.exc'
      ]
    }

    MORPHOLOGICAL_SUBSTITUTIONS = {
      :noun => [
        ['s',    ''   ],
        ['ses',  's'  ],
        ['ves',  'f'  ],
        ['xes',  'x'  ],
        ['zes',  'z'  ],
        ['ches', 'ch' ],
        ['shes', 'sh' ],
        ['men',  'man'],
        ['ies',  'y'  ]
      ],
      :verb => [
        ['s',   '' ],
        ['ies', 'y'],
        ['es',  'e'],
        ['es',  '' ],
        ['ed',  'e'],
        ['ed',  '' ],
        ['ing', 'e'],
        ['ing', '' ]
      ],
      :adj =>  [
        ['er',  '' ],
        ['est', '' ],
        ['er',  'e'],
        ['est', 'e']
      ],
      :adv =>  [
      ],
      :unknown => [
      ]
    }

    def initialize(dict = nil)
      @wordlists  = {}
      @exceptions = {}

      MORPHOLOGICAL_SUBSTITUTIONS.keys.each do |x|
        @wordlists[x]  = {}
        @exceptions[x] = {}
      end
      
      WN_FILES.each_pair do |pos, pair|
        load_wordnet_files(pos, pair[0], pair[1])
      end

      if dict
        [dict].flatten.each do |d|
          load_provided_dict(d)
        end
      end
    end

    def lemma(form, pos = nil)
      unless pos
        [:verb, :noun, :adj, :adv].each do |p|
          result = lemma(form, p)
          return result unless result == form
        end

        return form
      end

      each_lemma(form, pos) do |x|
        return x
      end

      form
    end

    # Print object only on init
    def inspect
      "#{self}"
    end

    private

    def open_file(*args)
      if args[0].is_a? IO or args[0].is_a? StringIO
        yield args[0]
      else
        File.open(*args) do |io|
          yield io
        end
      end
    end

    def load_wordnet_files(pos, list, exc)
      open_file(list) do |io|
        io.each_line do |line|
          w = line.split(/\s+/)[0]
          @wordlists[pos][w] = w
        end
      end

      open_file(exc) do |io|
        io.each_line do |line|
          w, s = line.split(/\s+/)
          @exceptions[pos][w] ||= []
          @exceptions[pos][w] << s
        end
      end
    end

    def each_substitutions(form, pos)
      if lemma = @wordlists[pos][form]
        yield lemma
      end

      MORPHOLOGICAL_SUBSTITUTIONS[pos].each do |entry|
        old, new = *entry
        if form.endwith(old)
          each_substitutions(form[0, form.length - old.length] + new, pos) do |x|
            yield x
          end
        end
      end
    end

    def each_lemma(form, pos)
      if lemma = @exceptions[pos][form]
        lemma.each { |x| yield x }
      end

      if pos == :noun && form.endwith('ful')
        each_lemma(form[0, form.length-3], pos) do |x|
          yield x + 'ful'
        end
      else

      each_substitutions(form, pos) do|x|
          yield x
        end
      end
    end

    def str_to_pos(str)
      case str
      when "n", "noun"
        return :noun
      when "v", "verb"
        return :noun
      when "a", "j", "adjective", "adj"
        return :adj
      when "r", "adverb", "adv"
        return :adv
      else
        return :unknown
      end
    end

    def load_provided_dict(dict)
      num_lex_added = 0
      open_file(dict) do |io|
        io.each_line do |line|
          # pos must be either n|v|r|a or noun|verb|adverb|adjective
          p, w, s = line.split(/\s+/)
          pos = str_to_pos(p)
          if @wordlists[pos]
            @wordlists[pos][w] = s
            num_lex_added += 1
          end
        end
      end
      # puts "#{num_lex_added} items added from #{File.basename dict}"
    end
  end
end
