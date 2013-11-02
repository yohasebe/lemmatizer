# -*- coding: utf-8; mode: ruby -*-

module Lematizer
  class ::String
    def endwith(s)
      self =~ /#{s}$/
    end
  end
end
