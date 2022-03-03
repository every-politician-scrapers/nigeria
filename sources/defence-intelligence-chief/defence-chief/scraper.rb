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

    def item_link
      name_cell.css('a').last
    end

    def item
      item_link.attr('wikidata')
    end

    def itemLabel
      item_link.text
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
