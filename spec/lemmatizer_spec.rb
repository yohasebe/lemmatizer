require 'spec_helper'
require 'lemmatizer'

describe 'Lemmatizer' do

  before(:all) do
    @lemmatizer = Lemmatizer.new
    user_data = File.join(File.dirname(__FILE__), "user.dict.txt")
    @lemmatizer_with_userdata = Lemmatizer.new(user_data)
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
      # Order: :verb, :noun, :adv, or :adj
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

    it 'can load user dict that overrides presets' do
      # 'MacBooks' -> 'MacBook'
      result_u1 = @lemmatizer_with_userdata.lemma('MacBooks', :noun)
      expect(result_u1).to eq('MacBook')
      # 'higher' -> 'high'
      result_u2 = @lemmatizer_with_userdata.lemma('higher', :adj)
      expect(result_u2).to eq('high')
      # 'highest' -> 'high'
      result_u3 = @lemmatizer_with_userdata.lemma('higher')
      expect(result_u3).to eq('high')
      # check if (unoverridden) preset data is kept intact
      result_u4 = @lemmatizer_with_userdata.lemma('crying', :verb)
      expect(result_u4).to eq('cry')
    end
  end
end
