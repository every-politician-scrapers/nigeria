#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Term'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name dates].freeze
    end

    def empty?
      (tds[0].text == tds[1].text) || (raw_combo_date.scan(/(\d{4})/).flatten.last.to_i < 2000)
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
