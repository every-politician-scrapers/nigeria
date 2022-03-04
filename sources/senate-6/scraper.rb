#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class SenatorList < Scraped::HTML
  decorator RemoveReferences
  # decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  field :members do
    member_entries.map { |ul| fragment(ul => Senator) }.reject(&:empty?).map(&:to_h)
  end

  private

  def member_entries
    noko.xpath('//table[contains(.,"Members")]//table//td//ul//li')
  end

  class Senator < Scraped::HTML
    def empty?
      noko.text.include? 'Vacant'
    end

    field :item do
      name_link.attr('wikidata') rescue binding.pry
    end

    field :itemLabel do
      name_link.text.tidy
    end

    field :state do
      noko.xpath('preceding::th[1]').text.tidy
    end

    private

    def name_link
      noko.css('a').last
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: SenatorList).csv
