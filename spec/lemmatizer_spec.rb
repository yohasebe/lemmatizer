#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'lemmatizer'

describe "Lemmatizer" do
	it "contains lemmatizing functions:" do
	end

	before do
		@lemmatizer = Lemmatizer.new
	end

	describe "lemma" do
		it "takes a word form and its part-of-speech symbol (:noun, :verb, :adj, :adv) and then returns its lemma form" do
			result_n1 = @lemmatizer.lemma("analyses", :noun)
			result_n1.should == "analysis"

      # Lemmatizer leaves alone words that its dictionary does not contain to keep proper names such as "James" intact.
			result_n2 = @lemmatizer.lemma("MacBooks", :noun)
			result_n2.should_not == "MacBook"

			result_n3 = @lemmatizer.lemma("desks", :noun)
			result_n3.should == "desk"

			result_v1 = @lemmatizer.lemma("hired", :verb)
			result_v1.should == "hire"

			result_v2 = @lemmatizer.lemma("worried", :verb)
			result_v2.should == "worry"

			result_v3 = @lemmatizer.lemma("partying", :verb)
			result_v3.should == "party"

			result_a1 = @lemmatizer.lemma("better", :adj)
			result_a1.should == "good"

			result_a2 = @lemmatizer.lemma("hotter", :adj)
			result_a2.should == "hot"

			result_r1 = @lemmatizer.lemma("best", :adv)
			result_r1.should == "well"

			result_r2 = @lemmatizer.lemma("best", :adv)
			result_r2.should_not == "good"
      
      # Lemmatizer give a result even when no pos is given, by assuming it to be :verb, :noun, :adv, or :adj.
			result_1 = @lemmatizer.lemma("plays")
			result_1.should == "play"

			result_2 = @lemmatizer.lemma("oxen")
			result_2.should == "ox"
      
			result_3 = @lemmatizer.lemma("higher")
			result_3.should_not == "high" # since 'higher' is itself contained in the adj list.
      
			result_2 = @lemmatizer.lemma("asdfassda") # non-existing word
			result_2.should == "asdfassda"
      
      # test cases for words used in README 
			result_t1 = @lemmatizer.lemma("fired")
			result_t1.should == "fire"

			result_t2 = @lemmatizer.lemma("slower")
			result_t2.should == "slow"      
		end
	end

end