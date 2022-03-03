#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      Name.new(
        full: stripped_name, 
        prefixes: %w[Engr Amb Sen Arc Dr Prince Major General Dame]
      ).short
    end

    def position
      position_and_name.first.split(/ and (?=Minister)/).map(&:tidy)
    end

    private

    def position_and_name
      tds[1].text.tidy.split(/[-–] /)
    end

    def stripped_name
      position_and_name[1].sub(/\(.*/, '')
    end

    def tds
      noko.css('td')
    end
  end

  class Members
    def member_container
      noko.css('.content-inner table').xpath('.//tr[td]')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
