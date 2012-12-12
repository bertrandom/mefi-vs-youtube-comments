#!/usr/bin/env ruby

require 'rubygems'
require 'feedzirra'
require 'mustache'

class Fight < Mustache
    self.template_path = File.dirname(__FILE__)
    def mefi_comments
    end
    def youtube_comments
    end
end

mefi_comments = []

#
# http://www.metafilter.com/122235/HI-KICK-CLAP-HI-HI-CLAP-HI-KICK-CLAP-I-AM-YOUR-MA-GIC-WAND------- contained invalid &#55357; entities for an XML document, breaking the parser.
# This manually strips those out before feeding it to the parser, otherwise we could have just used fetch_and_parse
#

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

if mefi_comments.length < 25 || youtube_comments.length < 25
    puts "There was an issue fetching some comments."
    exit
end

fight = Fight.new
fight[:mefi_comments] = mefi_comments
fight[:youtube_comments] = youtube_comments

fh = File.new(File.dirname(__FILE__) + "/web/index.html", "w")
fh.puts fight.render
fh.close
