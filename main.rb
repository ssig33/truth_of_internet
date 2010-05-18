#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
$KCODE = "u"
require 'thread'
require 'net/http'
require 'uri'
require 'rubygems'
require 'json'
require 'wedata'
require 'stream'
require 'word'
require 'pit'

config = Pit.get("hametsu_twitteR", :require => {
  "username" => "your email in Twitter",
  "password" => "your password in Twitter",
})

@ingos = get_ingo_list

USERNAME = config["username"]
PASSWORD = config["password"]
l = Queue.new
s = Queue.new

th1 = Thread.start do
  while r = l.pop
    print_str_color r["text"]
    sleep 0.5
  end
end

p1 = Thread.start do
  sample s
end

p2 = Thread.start do
  detect_sample_japanese s, l
end

p3 = Thread.start do
  search l
end

th1.join
