# -*- coding: utf-8 -*-
require 'rubygems'
require 'json'
require 'open-uri'
require 'cgi'
require 'memcache'

def cache
  MemCache.new "localhost:11978"
end

def sample q
  begin
    while true
      uri = URI.parse 'http://stream.twitter.com/1/statuses/sample.json'
      
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        # Streaming APIはBasic認証のみ
        request.basic_auth(USERNAME, PASSWORD)
        http.request(request) do |response|
          response.read_body do |chunk|
            # 空行は無視する = JSON形式でのパースに失敗したら次へ
            status = JSON.parse(chunk) rescue next
            # 削除通知など、'text'パラメータを含まないものは無視して次へ
            next unless status['text']
            user = status['user']
            q.push status
          end
        end
      end

    end
  rescue => e
    retry
  end
end

def detect_sample_japanese s, l
  while r = s.pop
    t = r["text"]
    if (/おっぱい/ =~t or /幼女/ =~t or /フェラ/ =~ t or /セックス/ =~t or /マンコ/ =~ t or /チンポ/ =~ t or /ペニス/ =~t or /レイプ/ =~t or /おまんこ/ =~t or /淫乱/ =~t or /オナニー/ =~t or /勃起/ =~t or /貧乳/ =~t or /ちんこ/ =~t or /ロリコン/ =~t or /巨乳/ =~t or /輪姦/ =~t or /強姦/ =~t or /オッパイ/ =~t or /おちんぽ/ =~t or /クンニ/ =~t or /きんたま/ =~t or /キンタマ/ =~t or /アナル/ =~t or /縞パン/ =~ t)
      l.push r
      cache["tweet_#{r["id"]}"] = r
    end
  end
end

def search l
  while true
    url = "http://search.twitter.com/search.json?q=#{CGI.escape("おっぱい OR 幼女 OR フェラ OR セックス OR マンコ OR チンポ OR ペニス OR レイプ OR おまんこ OR 淫乱")}&result_type=recent&rpp=100"
    result = JSON.parse(open(url).read)
    result["results"].each do |r|
      if cache["tweet_#{r["id"]}"] == nil
        l.push r
        cache["tweet_#{r["id"]}"] = r
      end
    end
    url = "http://search.twitter.com/search.json?q=#{CGI.escape("オナニー OR 勃起 OR 貧乳 OR ちんこ OR ロリコン OR 巨乳 OR 輪姦")}&result_type=recent&rpp=100"
    result = JSON.parse(open(url).read)
    result["results"].each do |r|
      if cache["tweet_#{r["id"]}"] == nil
        l.push r
        cache["tweet_#{r["id"]}"] = r
      end
    end
    url = "http://search.twitter.com/search.json?q=#{CGI.escape("強姦 OR オッパイ OR おちんぽ OR クンニ OR きんたま OR キンタマ OR アナル OR 縞パン")}&result_type=recent&rpp=100"
    result = JSON.parse(open(url).read)
    result["results"].each do |r|
      if cache["tweet_#{r["id"]}"] == nil
        l.push r
        cache["tweet_#{r["id"]}"] = r
      end
    end

    sleep 60
  end
end
