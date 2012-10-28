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
		end
	end

end