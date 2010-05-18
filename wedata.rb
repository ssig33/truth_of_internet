# -*- coding: utf-8 -*-
require 'rubygems'
require 'json'
require 'open-uri'
require 'cgi'
require 'memcache'

def get_ingo_list
  array = []
  we = JSON.parse(open("http://wedata.net/databases/%E6%B7%AB%E8%AA%9E/items.json").read)
  we.each do |w|
    array << w["data"]["japanese"]
  end
  return array
end
