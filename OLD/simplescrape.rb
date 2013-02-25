#simplescrape.rb
require 'open-uri'
require 'nokogiri'

url = "http://www.huffingtonpost.com/"   #Insert URL in quotes 
selector = "h1"                          #Insert CSS selector in quotes

doc = Nokogiri::HTML(open("#{url}"))
doc.css("#{selector}").each do |selector|
puts selector.text
end