#!/usr/bin/env ruby

require 'rubygems'
require 'feedzirra'
require 'mustache'

class Fight < Mustache
    def mefi_comments
    end
    def youtube_comments
    end
end

mefi_comments = []

mefi_xml = Feedzirra::Feed.fetch_raw('http://feeds2.feedburner.com/Metafilter')
mefi_xml = mefi_xml.gsub(/&#55357;/,'')
rss = Feedzirra::Feed.parse(mefi_xml)

rss.entries.each do |entry|

    puts "Metafilter - " + entry.title
    mefi_post_xml = Feedzirra::Feed.fetch_raw(entry.url + '/rss')
    mefi_post_xml = mefi_post_xml.gsub(/&#55357;/,'')
    mefi_post_rss = Feedzirra::Feed.parse(mefi_post_xml)
    mefi_post_rss.entries.each do |mefi_comment_entry|
        mefi_comments.push({'comment' => mefi_comment_entry.summary})
    end
end

youtube_comments = []
    
rss = Feedzirra::Feed.fetch_and_parse('http://gdata.youtube.com/feeds/api/standardfeeds/most_viewed')
rss.entries.each do |entry|
    puts "Youtube - " + entry.title
    video_rss = Feedzirra::Feed.fetch_and_parse(entry.id + '/comments')
    if video_rss.entries
        video_rss.entries.each do |video_comment_entry|
            youtube_comments.push({'comment' => video_comment_entry.content})
        end
    end
end

mefi_comments = mefi_comments.shuffle
youtube_comments = youtube_comments.shuffle

fight = Fight.new
fight[:mefi_comments] = mefi_comments
fight[:youtube_comments] = youtube_comments

fh = File.new(File.dirname(__FILE__) + "/web/index.html", "w")
fh.puts fight.render
fh.close