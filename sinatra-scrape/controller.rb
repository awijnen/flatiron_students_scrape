require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'data_mapper'
require 'dm-postgres-adapter'
require 'pry'
 
ENV['DATABASE_URL'] ||= 'postgres://Anthony:@localhost/studentscrape'
 
DataMapper.setup(:default, ENV['DATABASE_URL'])
 
DataMapper.auto_migrate!
 
class Student
  include DataMapper::Resource
 
  property :id, Serial
  property :name, String
  property :tagline, String
  property :short, Text
  property :aspirations, Text
  property :interests, Text
 
  @@url = 'http://students.flatironschool.com/'
  @@root_doc = Nokogiri::HTML(open(@@url))
 
  def self.pull_student_links
    @@links = @@root_doc.css('.columns').css('a').collect { |s| s['href'] }
  end
 
  def self.pull_all_student_profiles
    self.pull_student_links
    @@links.each { |link| self.new_from_url(@@url + link) }
  end
 
  def self.get_page(link)
    begin
      html = open(link) 
      Nokogiri::HTML(html)
    rescue => e
      puts "Failed to open #{link} because of #{e}"
    end
  end
 
  def self.new_from_url(url)
    doc = self.get_page(url)
    self.create(self.get_content(doc))
  end
 
  def self.get_content(doc)
    content_paths = {
      :name => '#about h1',
      :tagline => '#about h2',
      :short => '#about p:first-child',
      :aspirations => '#about p:nth-child(1)',
      :interests => '#about p:nth-child(2)'
    }   
    content_paths.each do |key, value|
      begin
        # ("#{key}=",doc.css(value).text)
        content_paths[key] = doc.css(value).text
      rescue Exception => e
       puts "Scrape error for content key: #{key} error: #{e}"
      end
    end
  end
 
  def self.find_by_name(name)
    self.first(:name=>name)
  end
 
  def self.find(id)
    self.get(id)
  end
 
end
 
DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  @students = Student.all :order => :id.asc
  erb :home
end

