require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://students.flatironschool.com"

### Selectors ###

# what information to we want to scrape?
information = []
information[0] = "student_name"
information[1] = "student_tagline"
information[2] = "student_excerpt"
information[3] = "student_profile_link"


# where is that information stored?
selectors = []
selectors[0] = "div.one_third h2" # student full name
selectors[1] = "div.position" # student tagline
selectors[2] = "p.excerpt" # student excerpt
selectors[3] = "section.about-us a" # student profile links


# ### Creating hashes ###
students_hash = {:student => {}}
# {
#   :student => {
#     :anthonywijnen => {
#       :information => {
#         :tagline => "my tagline",
#         :excerpt => "my excerpt"
#       },
#       :profile_link => "http://..."
#     }
#   }
# }


### create doc ###
doc = Nokogiri::HTML(open("#{url}"))


### Scrape ####

# ### Check names ###
# doc.css("#{selectors[0]}").each do |selector|
#   puts selector.text
# end
# # Alternative approach: puts doc.css("div.name-position h2").text

# ### Check taglines ###
# doc.css("#{selectors[1]}").each do |selector|
#   puts selector.text
# end

# ### Check excerpts ###
# doc.css("#{selectors[2]}").each do |selector|
#   puts selector.text
# end

# ### Check URLs ###
# link_array = []
# doc.css("#{selectors[3]}").each do |selector|
#   link_array << selector['href'] if !link_array.include?(selector['href']) # to combat duplicate yanikjayaram.html
# end
# puts link_array


### Put all names in an array ###
student_name_array = []

doc.css("div.one_third h2").each do |selector|
  student_name_array << selector.text
end
puts student_name_array

### Put all taglines in an array ###
student_tagline_array = []

doc.css("#{selectors[1]}").each do |selector|
  student_tagline_array << selector.text
end


### Put all excerpts in an array ###
student_excerpt_array = []

doc.css("#{selectors[2]}").each do |selector|
  student_excerpt_array << selector.text
end

### Put all links in an array ###
student_link_array = []

doc.css("#{selectors[3]}").each do |selector|
  stripped_selector = selector['href'].sub("./","")
  student_link_array << stripped_selector if !student_link_array.include?(stripped_selector)
end

### Concatenate name, tagline, and excerpt
student_conc_array = []

(0..student_name_array.length-1).each do |i|
  student_conc_array[i] = [student_name_array[i], student_tagline_array[i], student_excerpt_array[i], student_link_array[i]]
end


# ### Test if arrays are equal in length ###
# puts student_name_array
# puts student_name_array.length
# puts student_tagline_array
# puts student_tagline_array.length
# puts student_excerpt_array
# puts student_excerpt_array.length
# puts student_link_array
# puts student_link_array.length
# puts student_conc_array
# puts student_conc_array.length


### Create student hash
student_conc_array.each_with_index do |individual_conc_array|
  full_name = individual_conc_array[0]
  tagline = individual_conc_array[1]
  excerpt = individual_conc_array[2]
  profile_link = individual_conc_array[3]

  first_name = full_name.split(" ").first
  last_name = full_name.split(" ").last
  name_concat = (first_name + "_" + last_name).downcase
 
  # puts name_concat

  if !students_hash[:student][name_concat.to_sym]
    students_hash[:student][name_concat.to_sym] = {
      :information => {:tagline => "#{tagline}", :excerpt => "#{excerpt}"},
      :profile_link => "#{profile_link}"
    }
  end
 
end

### Find data for one particular student ###
# puts students_hash[:student][:anthony_wijnen][:information][:tagline]
# puts students_hash[:student][:anthony_wijnen][:information][:excerpt]
# puts students_hash[:student][:anthony_wijnen][:profile_link]

### Find student name, tagline, and excerpt for all student ###
# students_hash[:student].each do |student, data|
#   p "#{student}"
#   p data[:information][:tagline]
#   p data[:information][:excerpt]
#   p data[:profile_link]
# end






