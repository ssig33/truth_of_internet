#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'term/ansicolor'
include Term::ANSIColor

def print_str_color str
    @ingos.each do |w|
    if /#{w}/ =~ str
      @a = process_str str, w
      break
    end
  end
  a = @a
  a.each_with_index do |i,k|
    print i
    if k%2 == 1
      print reset
    end
    if k%2 == 0
      print red
    end
  end
  print reset,"\n"
end

def process_str str,word
  a = Array.new
  str.split(word).each_with_index do |s,i|
    a << s
    if (i%2 == 0 or i >= 1) and  i != (str.split(word).size - 1)
      a << word
    end
  end
  return a
end

#print_str_color "ぜひとも！おっぱい！ RT @ibiru: インターネット＆サブカル系編集者です。先生、またカラオケにて RT @otonaryoku お、！　ど、どうして呼んでくださらなかったんですか！ RT @nonakaaan: おっぱい大きいＪＪとの飲み楽しかったなう"
