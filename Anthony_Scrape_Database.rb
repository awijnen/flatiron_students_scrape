require 'nokogiri'
require 'open-uri'
require 'pp'
require "sqlite3"
require 'pry'

# Create database
DB = SQLite3::Database.new "profile_scrape.db"

rows = DB.execute <<-SQL
  CREATE TABLE students (
    id integer PRIMARY KEY,
    name varchar(255),
    bio varchar(255),
    aspirations varchar(255),
    tagline varchar(255),
    work varchar(255)
  );
SQL


# Scrape class
class Scrape 

  def get_links(url='http://students.flatironschool.com/')
    doc = get_page(url) # equals the Nokogiri document
    people = doc.css("div.name-position")
    links = []
    people.each { |person| links << url + '/' + person.parent["href"] } # 
    links
  end

  def get_page(link)
    begin
      html = open(link) 
      Nokogiri::HTML(html) # returns Nokogiri document
    rescue => e
      puts "Failed open #{link} because of #{e}"
    end
  end

  def create_student(student_info)
    Student.new(student_info)
  end


  def parse_profile(doc)
    name = doc.at("div.two_third h1").text
    tagline = doc.at("div.two_third h2").text
    main_body = doc.css("div.two_third")

    jobs = doc.css("section#former_life ul")[0]/('a')

    work = {}
    jobs.each {|job| work[job.text.to_sym] = job['href'] }

    bio = doc.css("div.two_third h1 ~ p").text
    aspirations = doc.css("div.two_third h2 ~ p").text

    student_info = {
      :name => name,
      :bio => bio,
      :aspirations => aspirations,
      :tagline => tagline,
      :work => work
    }

  end



  def run
    links = get_links('http://students.flatironschool.com/')
    links.each do |link| 
      begin
      profile = get_page(link)
      student = parse_profile(profile)
      puts create_student(student)
      rescue => e
        puts e
      next
      end
    end
  end

end


# Student class
class Student
  attr_accessor :name, :bio, :aspirations, :tagline, :work

  @students = []

  def self.all
    @students
  end

  def initialize(values_hash)
    # binding.pry
    values_hash.each do |key,value| 
      self.send(key.to_s+"=", value) # will run method name=, with argument 'name you scraped'
      # self.save
      self.class.all << self # add instance to @students array
    end
    self.save  
  end

  def save
    DB.execute("INSERT INTO students (name, bio, aspirations, tagline, work)
            VALUES (?, ?, ?, ?, ?)", [self.name, self.bio, self.aspirations, self.tagline, self.work])
  end

end

