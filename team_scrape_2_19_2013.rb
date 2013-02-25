require 'nokogiri'
require 'open-uri'
require 'pp'
require "sqlite3"
require 'pry'

###################################################################

class Scrape
  
  attr_accessor :url, :student_link_array, :student_doc_array, :student_data_array

  def initialize
    @url = "http://students.flatironschool.com/"
  end

  def get_index_nokogiri # get nokogiri element of index page
    @doc = Nokogiri::HTML(open(url))
  end

  def get_student_link_array # get links for every student from index
    @student_link_array = @doc.css("div.name-position").collect { |student| url + student.parent["href"] }
  end

  def get_profile_nokogiri # get nokogiri element of one student
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

  def get_all_student_data # iterator method, iterate over every student in the student_data_array
    @student_data_array = []
    
    @student_doc_array.each do |student_doc|
      add_student(student_doc)
    end

  end

  def add_student(student_doc) # add one student
    get_name_data(student_doc)
    get_bio_data(student_doc)
    get_aspirations_data(student_doc)
    get_social_media_links_data(student_doc)
    add_student_to_array
    create_student
  end

  def get_name_data(student_doc) # get name for one student
    @name_selector = "div.two_third.last h1"
    @name_data = student_doc.css(@name_selector).text
  end


  def get_bio_data(student_doc) # get bio for one student
    @bio_selector = "div.two_third.last h2 + p"
    @bio_data = student_doc.css(@bio_selector).text
  end


  def get_aspirations_data(student_doc) # get aspirations for one student
    @aspirations_selector = "div.two_third.last h3:nth-child(4) + p"
    @aspirations_data = student_doc.css(@aspirations_selector).text
  end


  def get_social_media_links_data(student_doc) # get social media links for one student
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


  def add_student_to_array # aggregate the data of one student and add the entire student to an array
    student_hash = {
      @name_data.to_sym => {
        :bio => @bio_data,
        :aspirations => @aspirations_data,
        :social_media_links => @social_media_links_data
      }
    }
    
    @student_data_array << student_hash
     
  end


  def create_student # create new Student class instance
    individual_student_data_array = [@name_data, @bio_data, @aspirations_data, @social_media_links_data]
    Student.new(individual_student_data_array)
  end


  def run # collection of all major methods => this sets the whole thing in motion
    get_index_nokogiri
    get_student_link_array
    get_profile_nokogiri
    get_all_student_data
  end

end

###################################################################

class Student

  # attr_accessor :name, :bio, :aspirations, :social_media_links

  ATTRIBUTES = {
    :name => :text,
    :bio => :text,
    :aspirations => :text,
    :social_media_links => :text
  }

  @students = []

  def self.all
    @students
  end

  @@db = SQLite3::Database.new('scrape.db')

  ATTRIBUTES.each do |attribute, type|
    attr_accessor attribute
  end
 
  def self.attributes
    ATTRIBUTES.keys
  end
 
  def self.attributes_hash
    ATTRIBUTES
  end
 
  def self.table_name
    "students"
  end
 
 
  def self.columns_for_sql
    columns_for_sql_array = []
    columns_for_sql_array << "id INTEGER PRIMARY KEY"
    self.attributes_hash.each do |k,v| 
      columns_for_sql_array << "#{k.to_s.downcase} #{v.to_s.upcase}"
    end
    columns_for_sql_array.join(",")
  end


  def self.create_table
    @@db.execute "CREATE TABLE IF NOT EXISTS students (#{self.columns_for_sql});"
  end

  def self.column_select_find
    puts "Here are the columns you can retrieve from the #{@tableName} table:"
    puts "[1] id\n[2] name\n[3] bio\n[4] aspirations\n[5] social media links\n"
    puts "Enter column names (comma delimited, no spaces):"
    column_select = gets.strip.downcase
  end

  def self.name_select_find
    puts "----------------------------------------"
    puts "Here's a list of students:"
    self.list_of_student_names
    puts "Enter name of student you want to look up:"
    name = gets.strip
  end

  def self.find_anthony
    @@db.execute( "SELECT #{self.column_select_find}
                   FROM (#{@tableName})
                   WHERE name='#{self.name_select_find}'" ) do |row|
      puts "----------------------------------------"
      puts row
    end
  end

  def self.find_by_name(name)
    self.all.each_with_index do |student, index|
      if student.name == name
        return student.name
      else
        puts "Name not found."
      end
    end
  end

  def self.flush_database
    @@db.execute( "DELETE FROM " + self.table_name )
  end

  def self.list_of_student_names
   @students.each {|student| puts student.name}
  end

  # Execute once when class is created
  @tableName = self.table_name
  self.create_table
  self.flush_database


  def initialize(student_data=[[],[],[],[]])
    if student_data[0].length != 0
      @name, @bio, @aspirations, @social_media_links = student_data
      self.save
    else
    end
    self.class.all << self
  end

  def save
    if self.social_media_links != nil
    @@db.execute(
      "INSERT INTO students (name, bio, aspirations, social_media_links) VALUES (?, ?, ?, ?)", [self.name, self.bio, self.aspirations, self.social_media_links.values.join(",")])
    else
   @@db.execute(
     "INSERT INTO students (name, bio, aspirations, social_media_links) VALUES (?, ?, ?, ?)", [self.name, self.bio, self.aspirations, self.social_media_links])
    end
  end


end

# ###################################################################

#   ATTRIBUTES = {
#     :id => :integer,
#     :name => :text,
#     :bio => :text,
#     :aspirations => :text,
#     :social_media_links => :text
#   }

#   @@db = SQLite3::Database.new('scrape.db')

#   ATTRIBUTES.each do |attribute, type|
#     attr_accessor attribute
#   end
 
#   def self.attributes
#     ATTRIBUTES.keys
#   end
 
#   def self.attributes_hash
#     ATTRIBUTES
#   end
 
#   def self.table_name
#     "students"
#   end
 
#   @tableName = self.table_name
 
#   def self.columns_for_sql
#     self.attributes_hash.collect { |k, v| "#{k.to_s.downcase} #{v.to_s.upcase}" }.join(",")
#   end


#   def self.create_table
#     @@db.execute "CREATE TABLE IF NOT EXISTS students (#{self.columns_for_sql});"
#   end
 
#   self.create_table

#   ###################################################################

# Run it #
scrape = Scrape.new
scrape.run
Student.find_anthony
