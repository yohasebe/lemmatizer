#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

target = ARGV[0]
base = File.basename(target)

case base
when /\.noun/
  mode = :noun
when /\.verb/
  mode = :verb
when /\.adj/
  mode = :adj
when /\.adv/
  mode = :adv
end
  
newtarget = base + "-mod"

infile = File.open(target)
lines = infile.readlines
infile.close

results = {}
lines.each do |line|
  /^([^\s]+)/ =~ line
  case mode
  when :noun
    lemma = $1.sub(/s\z/, "").sub(/e\z/, "")
  when :verb
    lemma = $1.sub(/s\z/, "").sub(/d\z/, "").sub(/ing\z/, "").sub(/e\z/, "")
  when :adj
    lemma = $1.sub(/r\z/, "").sub(/st\z/, "").sub(/e\z/, "").sub(/i\z/, "")
  when :adv
    lemma = $1.sub(/r\z/, "").sub(/st\z/, "").sub(/e\z/, "").sub(/i\z/, "")
  end
  if results[lemma]
    next
  else
    results[lemma] = line
  end
end

outfile = File.open(newtarget, "w")
outfile.write(results.values.join(""))
outfile.close
