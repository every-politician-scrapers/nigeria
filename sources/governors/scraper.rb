#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class MinistersList < Scraped::HTML
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  field :governors do
    member_entries.map { |ul| fragment(ul => Officeholder).to_h }
      .reject { |row| row[:stateLabel].include? 'Capital' }
  end

  private

  def member_entries
    table.flat_map { |table| table.xpath('.//tr[td]') }
  end

  def table
    noko.xpath('//table[.//th[contains(.,"Governor")]]')
  end
end

class Officeholder < Scraped::HTML
  field :stateLabel do
    tds[0].text.tidy
  end

  field :governor do
    tds[2].css('a/@wikidata').text
  end

  field :governorLabel do
    tds[2].text.tidy
  end

  field :start do
    tds[7].text.to_i
  end

  private

  def tds
    noko.css('td')
  end
end

url = 'https://en.wikipedia.org/wiki/List_of_state_governors_of_Nigeria'
data = MinistersList.new(response: Scraped::Request.new(url: url).response).governors

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
