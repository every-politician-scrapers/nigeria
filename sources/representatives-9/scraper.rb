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

  def table_number
    'position()>0'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[constituency name party dates].freeze
    end

    field :party do
      party_link.attr('wikidata')
    end

    field :partyLabel do
      party_link.text.tidy
    end

    def empty?
      tds[1].text.include? 'Vacant'
    end

    def raw_combo_date
      super.gsub('Unknown', '2019').gsub('present', 'incumbent')
    end

    def party_link
      tds[columns.index('party')].css('a')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
