require 'open-uri'
require 'nokogiri'
require 'pp'

class Scrape
  
  attr_accessor :url, :student_link_array, :student_doc_array, :student_data_array

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
        puts "ALERT: Failed to get Nokogiri element for #{link}."
        puts e
      end

    end
    # @student_doc_array = @student_link_array.collect { |url| Nokogiri::HTML(open(url)) }

  end

  # def get_student_data
  #   # return hash of data
  # end

  def get_all_student_data
    @student_data_array = []
    
    @student_doc_array.each do |student_doc|
      add_student(student_doc)
    end

  end

  def add_student(student_doc)
    get_name_data(student_doc)
    get_bio_data(student_doc)
    get_aspirations_data(student_doc)
    get_social_media_links_data(student_doc)
    add_student_to_array
  end

  def get_name_data(student_doc)
    @name_selector = "div.two_third.last h1"
    @name_data = student_doc.css(@name_selector).text
  end

  def get_bio_data(student_doc)
    @bio_selector = "div.two_third.last h2 + p"
    @bio_data = student_doc.css(@bio_selector).text
  end

  def get_aspirations_data(student_doc)
    @aspirations_selector = "div.two_third.last h3:nth-child(4) + p"
    @aspirations_data = student_doc.css(@aspirations_selector).text
  end

  def get_social_media_links_data(student_doc)
    @social_media_links_selector = "div.social_icons i"
    @social_media_links_data = {}
    student_doc.css(@social_media_links_selector).each do |i_element|
      link_type = i_element['class'].gsub("icon-","")
      link_href = i_element.parent['href']
      if !@social_media_links_data[link_type.to_sym]
        @social_media_links_data[link_type.to_sym] = link_href
      end
    end
  end

  def add_student_to_array
    student_hash = {
      @name_data.to_sym => {
        :bio => @bio_data,
        :aspirations => @aspirations_data,
        :social_media_links => @social_media_links_data
      }
    }
    
    @student_data_array << student_hash
     
  end

  def run
    get_index_nokogiri
    get_student_link_array
    get_profile_nokogiri
    get_all_student_data
  end

end