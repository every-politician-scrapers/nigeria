#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class SlashDMY < WikipediaDate
  def to_s
    date_en.to_s.split('/').reverse.join('-')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h2[contains(.,'Secretaries')][1]//following-sibling::ul[1]//li[a]")
  end

  class Officeholder < OfficeholderBase
    def raw_combo_date
      noko.text.scan(/\((.*?)\)/).flatten.last
    end

    def combo_date?
      true
    end

    def item
      name_cell.attr('wikidata')
    end

    def name
      nake_cell.text.tidy
    end

    def name_cell
      noko.css('a').last
    end

    def empty?
      false
    end

    def date_class
      SlashDMY
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
