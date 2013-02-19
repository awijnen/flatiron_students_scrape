require 'open-uri'
require 'nokogiri'
require 'pp'

class Scrape
  
  attr_accessor :url

  def initialize
    @url = "http://students.flatironschool.com/"
  end

  def get_index_nokogiri
    @doc = Nokogiri::HTML(open(url))
  end

  def get_student_link_array
    @student_link_array = @doc.css("div.name-position").collect { |student| url + student.parent["href"] }
  end

  def get_profile_nokogiri
    @student_doc_array = []
    @student_link_array.each do |link|
      begin
        @student_doc_array << Nokogiri::HTML(open(link))
        puts "Getting Nokogiri element for #{link}"
      rescue => e
        puts e
      end

    end
    # @student_doc_array = @student_link_array.collect { |url| Nokogiri::HTML(open(url)) }

  end

  # def get_student_data
  #   # return hash of data
  # end


  def run
    get_index_nokogiri
    get_student_link_array
    get_profile_nokogiri
    # get_student_data
  end

end