#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portfolio'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[posn name start end].freeze
    end

    field :position do
      tds[0].text.tidy
    end

    def empty?
      tds[0].text == tds[1].text rescue binding.pry
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
