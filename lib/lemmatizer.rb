#! /usr/bin/env ruby
# -*- coding: utf-8; mode: ruby -*-

# Inspired by nltk.corpus.reader.wordnet.morphy http://nltk.googlecode.com/svn/trunk/doc/api/nltk.corpus.reader.wordnet-pysrc.html#WordNetCorpusReader.morphy
# Original code posted by mtbr at http://d.hatena.ne.jp/mtbr/20090303/prfrnlprubyWordNetbasedlemmatizer


require "lemmatizer/version"
require "stringio"

class String
	def endwith(s)
		self =~ /#{s}$/
	end
end

class Lemmatizer
	current_dir = File.expand_path(File.dirname(__FILE__))
	WN_FILES = {:noun => [current_dir + "/dict/index.noun", current_dir + "/dict/noun.exc"],
							:verb => [current_dir + "/dict/index.verb", current_dir + "/dict/verb.exc"],
							:adj  => [current_dir + "/dict/index.adj", current_dir + "/dict/adj.exc"],
							:adv  => [current_dir + "/dict/index.adv", current_dir + "/dict/adv.exc"]}

	MORPHOLOGICAL_SUBSTITUTIONS = {
		:noun => [['s', ''], ['ses', 's'], ['ves', 'f'], ['xes', 'x'],
								['zes', 'z'], ['ches', 'ch'], ['shes', 'sh'],
							 ['men', 'man'], ['ies', 'y']],
		:verb => [['s', ''], ['ies', 'y'], ['es', 'e'], ['es', ''],
							 ['ed', 'e'], ['ed', ''], ['ing', 'e'], ['ing', '']],

		:adj =>  [['er', ''], ['est', ''], ['er', 'e'], ['est', 'e']],
		:adv =>  []}

	def initialize(files = WN_FILES)
		@wordlists = {}
		@exceptions = {}
		MORPHOLOGICAL_SUBSTITUTIONS.keys.each do |x|
			@wordlists[x] = {}
			@exceptions[x] = {}
		end
		if files then
			files.each_pair do |pos,pair|
				load_wordnet_files(pos, pair[0], pair[1])
			end
		end
	end

	def open_file(*args)
		if args[0].is_a? IO or args[0].is_a? StringIO then
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
				w,s = line.split(/\s+/)
				@exceptions[pos][w] ||= []
				@exceptions[pos][w] << s
			end
		end
	end

	def each_lemma(form, pos)
		if lemma = @exceptions[pos][form] then
			lemma.each{|x |yield x}
		end
		if pos == :noun and form.endwith('ful')
			each_lemma(form[0,form.length-3], pos) do |x|
				yield x+'ful'
			end
		else
			_each_substitutions(form, pos) do|x|
				yield x
			end
		end
	end

	def lemma(form,pos)
		each_lemma(form, pos) do |x|
			return x
		end
		return form
	end
	def _each_substitutions(form, pos)
		if lemma = @wordlists[pos][form] then
			yield lemma
		end
		MORPHOLOGICAL_SUBSTITUTIONS[pos].each do |entry|
			old, new = *entry
			if form.endwith(old)
				_each_substitutions(form[0, form.length - old.length] + new, pos) do|x|
					yield x
				end
			end
		end
	end
end