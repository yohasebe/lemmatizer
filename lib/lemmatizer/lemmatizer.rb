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
      ]
    }

    def initialize(files = WN_FILES)
      @wordlists  = {}
      @exceptions = {}

      MORPHOLOGICAL_SUBSTITUTIONS.keys.each do |x|
        @wordlists[x]  = {}
        @exceptions[x] = {}
      end

      if files
        files.each_pair do |pos, pair|
          load_wordnet_files(pos, pair[0], pair[1])
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
  end
end
