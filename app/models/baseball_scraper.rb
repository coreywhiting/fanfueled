require 'nokogiri'
require 'open-uri'

class BaseballScraper

  attr_reader :url, :data

  def initialize(url)
    @url = url
  end

  def get_class_items(c)
    data.css(c)
  end

  def data
    @data ||= Nokogiri::HTML(open(url))
  end

  end