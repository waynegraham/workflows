# frozen_string_literal: true

require 'chronic'
require 'colorize'
require 'rss'

require 'date'
require 'erb'

require 'rss/2.0'
require 'open-uri'
require 'fileutils'
require 'safe_yaml'

module Utils
  def self.format_filename(item)
    "#{Utils.format_date(item)}-#{Utils.format_title(item)}"
  end

  def self.format_date(item)
    item.date.strftime('%Y-%m-%d')
  end

  def self.format_title(item)
    item.title.split(%r{ |!|\?|/|:|&|-|$|,|“|”|’}).map do |i|
      i.downcase if i != ''
    end.compact.join('-')
  end

  def self.clean_website(url)
    url = "http://#{url}" unless url[%r{^https?://}] || url.empty?
    url
  end

  def self.write_file(path, contents)
    file = File.open(path, 'w')
    file.write(contents)
  rescue IOError => e
    puts 'File not writable. Check your permissions'
    puts e.inpsect
  ensure
    file&.close
  end

  def self.header(item)
    {
      'layout' => 'post',
      'title' => item.title,
      'date' => item.date.strftime('%Y-%m-%d %T %z')
    }
  end

  def self.write_post(item)
    name = Utils.format_filename(item)
    header = Utils.header(item)

    File.open("_posts/#{name}.html", 'w') do |f|
      puts "Importing #{name}".green
      f.puts header.to_yaml
      f.puts "---\n\n"
      f.puts item.content_encoded
    end
  end
end

module Rss
  def self.import(feed_url)
    URI.open(feed_url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        Utils.write_post(item)
      end
    end
  end
end
