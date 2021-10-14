require 'spec_helper'
require 'lemmatizer'

describe 'Lemmatizer' do

  before(:all) do
    @lemmatizer = Lemmatizer.new
    user_data1 = File.join(File.dirname(__FILE__), "user.dict1.txt")
    user_data2 = File.join(File.dirname(__FILE__), "user.dict2.txt")
    user_data3 = File.join(File.dirname(__FILE__), "user.dict3.txt")
    @lemmatizer_single_userdict = Lemmatizer.new(user_data1)
    @lemmatizer_multiple_userdicts = Lemmatizer.new([user_data2, user_data3])
  end

  describe '#lemma' do
    it 'takes a noun and returns its lemma' do
      result_n1 = @lemmatizer.lemma('analyses', :noun)
      expect(result_n1).to eq('analysis')

      result_n3 = @lemmatizer.lemma('desks', :noun)
      expect(result_n3).to eq('desk')
    end

    it 'takes a verb and returns its lemma' do
      result_v1 = @lemmatizer.lemma('hired', :verb)
      expect(result_v1).to eq('hire')

      result_v2 = @lemmatizer.lemma('worried', :verb)
      expect(result_v2).to eq('worry')

      result_v3 = @lemmatizer.lemma('partying', :verb)
      expect(result_v3).to eq('party')
    end

    it 'takes an adjective and returns its lemma' do
      result_a1 = @lemmatizer.lemma('better', :adj)
      expect(result_a1).to eq('good')

      result_a2 = @lemmatizer.lemma('hotter', :adj)
      expect(result_a2).to eq('hot')
    end

    it 'takes an adverb and returns its lemma' do
      result_r1 = @lemmatizer.lemma('best', :adv)
      expect(result_r1).to eq('well')

      result_r2 = @lemmatizer.lemma('best', :adv)
      expect(result_r2).not_to eq('good')
    end

    it 'gives a result when no pos is given' do
      # Order: :verb, :noun, :adv, :adj, or :abbr
      result_1 = @lemmatizer.lemma('plays')
      expect(result_1).to eq('play')

      result_2 = @lemmatizer.lemma('oxen')
      expect(result_2).to eq('ox')

      # 'higher' is itself contained in the adj list.
      result_3 = @lemmatizer.lemma('higher')
      expect(result_3).not_to eq('high')

      # Non-existing word
      result_2 = @lemmatizer.lemma('asdfassda')
      expect(result_2).to eq('asdfassda')

      # Test cases for words used in README
      result_t1 = @lemmatizer.lemma('fired')
      expect(result_t1).to eq('fire')

      result_t2 = @lemmatizer.lemma('slower')
      expect(result_t2).to eq('slow')
    end

    it 'leaves alone words that dictionary does not contain' do
      # Such as 'James' or 'MacBooks'
      result_n2 = @lemmatizer.lemma('MacBooks', :noun)
      expect(result_n2).not_to eq('MacBook')
    end

    it 'can load a user dict that overrides presets' do
      # 'MacBooks' -> 'MacBook'
      result_u1 = @lemmatizer_single_userdict.lemma('MacBooks', :noun)
      expect(result_u1).to eq('MacBook')
      # 'iPhones' -> 'iPhone'
      result_u2 = @lemmatizer_single_userdict.lemma('iPhones', :noun)
      expect(result_u2).to eq('iPhone')
    end

    it 'can load uder dicts that override presets' do
      # 'higher' -> 'high'
      result_ud3 = @lemmatizer_multiple_userdicts.lemma('higher')
      expect(result_ud3).to eq('high')
      # check if (unoverridden) preset data is kept intact
      result_ud4 = @lemmatizer_multiple_userdicts.lemma('crying', :verb)
      expect(result_ud4).to eq('cry')
      # 'I'm' -> 'I am'
      result_ud5 = @lemmatizer_multiple_userdicts.lemma("I'm", :abbr)
      expect(result_ud5).to eq('I am')
      # 'You're' -> 'you are'
      result_ud6 = @lemmatizer_multiple_userdicts.lemma("You're", :abbr)
      expect(result_ud6).to eq("you are")
      # 'you're' -> 'you are'
      result_ud7 = @lemmatizer_multiple_userdicts.lemma("you're", :abbr)
      expect(result_ud7).to eq("you are")
      # 'h2s' -> 'Hydrogen Sulphide'
      result_ud8 = @lemmatizer_multiple_userdicts.lemma("h2s", :abbr)
      expect(result_ud8).to eq("Hydrogen Sulphide")
      # 'utexas' -> 'University of Texas'
      result_ud9 = @lemmatizer_multiple_userdicts.lemma("utexas", :abbr)
      expect(result_ud9).to eq("University of Texas")
      # 'mit' -> 'Massachusetts Institute of Technology'
      result_ud10 = @lemmatizer_multiple_userdicts.lemma("mit", :abbr)
      expect(result_ud10).to eq("Massachusetts Institute of Technology")
    end

    context 'performance' do
      describe '#assign_wordlists' do
        let!(:lemmatizer) do
          klass = Class.new(Lemmatizer::Lemmatizer) do
            def assign_wordlists(line, pos)
              w = line.split(/\s+/)[0]
              @wordlists[pos][w] = w
            end
          end
          klass.new
        end
        let(:wordlists_instance) { lambda { |source| source.instance_variable_get("@wordlists") } }
        let(:lem) { 'anything' }

        it { expect { @lemmatizer.lemma(lem) }.to perform_faster_than { lemmatizer.lemma(lem) }.warmup(2).at_most(10).times }
        it { expect(wordlists_instance[@lemmatizer]).to eq(wordlists_instance[lemmatizer]) }
      end
    end
  end
end
