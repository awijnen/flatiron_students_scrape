require 'open-uri'
require 'nokogiri'

######## GET ALL STUDENTS ########

# url to all student profiles, i.e index url
index_url = 'http://students.flatironschool.com'

# Create Nokogiri Document #
index_doc = Nokogiri::HTML(open("#{index_url}"))

# Create array comprised of the names of all students
student_name_array_selector = "div.one_third h2"
student_name_array = []

index_doc.css(student_name_array_selector).each do |student_name|
  student_name_array << student_name.text
end
# puts student_name_array

# Create array for aggregate student hash
student_name_aggregate_array = []

student_name_array.each do |name|
  student_name_aggregate_array << name.gsub(/\s+/, "")
end

# Create array of URLs
student_url_selector = "div.one_third a:first-of-type"
student_link_array = []

index_doc.css(student_url_selector).each do |individual_node|
  stripped_selector = individual_node['href'].sub("./","")
  student_link_array << stripped_selector if !student_link_array.include?(stripped_selector)
end

# puts student_link_array
# puts student_link_array
# puts student_name_array
# puts student_name_aggregate_array





# ######## ONE STUDENT ########

# # Create Nokogiri Document #
# student_doc = Nokogiri::HTML(open("http://students.flatironschool.com/" + student_link_array[0]))
 

# # creating selectors
# student_name_selector = "div.two_third h1"
# student_name = student_doc.css(student_name_selector).first.content 
# # .text and .content are the same
# # first picks the first element out of the nodeset (just like picking the first element out of an array)
# # puts student_name

# student_img_selector = "section#about div.one_third img"
# student_img = student_doc.css(student_img_selector).first['src']
# # puts student_img

# student_tagline_selector = "div.two_third h2"
# student_tagline = student_doc.css(student_tagline_selector).first.content
# # puts student_tagline

# student_bio_selector = "div.two_third h2 + p"
# # student_bio = student_doc.css(student_tagline_selector).next_element.content
# student_bio = student_doc.css(student_bio_selector).first.content
# # puts student_bio

# h3_selectors = "div.two_third h3"
# h3_p_selectors = "div.two_third h3 + p"

# # collect about titles in nodeset
# h3_in_about = student_doc.css(h3_selectors)
# # puts h3_in_about
# # puts h3_in_about.class

# # collect about titles in array, without selector
# h3_titles = h3_in_about.collect{|h3| h3.content}
# # puts h3_titles
# # puts h3_titles.class

# ps_in_h3_in_about = student_doc.css(h3_p_selectors)
# # puts ps_in_h3_in_about

# h3_p_content = ps_in_h3_in_about.collect{|p| p.content}
# # puts h3_p_content # this is an array of content

# # alternative to {|p| p.content}
# # h3_p_content = ps_in_h3_in_about.collect(&:content)
# # puts h3_p_content

# # about_student = Hash[*h3_titles.zip(h3_p_content).flatten]

# # # Data Structure
# #   about_student = {
# #     :Aspirations => "text content",
# #     :Interests => "text content"
# #     :social_links ==> [
# #       :globe => "url",
# #       :twitter => "url",
# #       :linkedin => "url"
# #       ]
# #   }


# about_student = {}
# h3_titles.each_with_index do |h3_content, index|
#   about_student[h3_content.to_sym] = h3_p_content[index]
# end
# # puts about_student

# # blog_link_selector = "i.icon-globe"
# # blog_link = student_doc.css(blog_link_selector).first.parent['href'] if student_doc.css(blog_link_selector).first

# social_links_selector = "div.social_icons i"
# social_link_elements = student_doc.css(social_links_selector)
# # puts social_link_elements

# social_links = []

# # for every i in social links
# social_link_elements.each do |i_element|
#   # get the class of the i and strip off the icon-
#   link_type = i_element['class'].gsub("icon-", "")
#   # then go up to the parent a and get the href
#   link_href = i_element.parent['href']
#   # puts link_href
#   # group those together as a key value pair
#   social_links << {link_type.to_sym => link_href}
# end
# # puts social_links

# # add social_links array to about_student hash
# about_student[:social_links] = social_links
# puts about_student



######## THREE STUDENTs ########

# Create Nokogiri Document #

student_aggregate_array = []

counter = 0

while counter < 9

  begin
    student_doc = Nokogiri::HTML(open("http://students.flatironschool.com/" + student_link_array[counter]))
     

    # creating selectors
    student_name_selector = "div.two_third h1"
    student_name = student_doc.css(student_name_selector).first.content 
    # .text and .content are the same
    # first picks the first element out of the nodeset (just like picking the first element out of an array)
    # puts student_name

    student_img_selector = "section#about div.one_third img"
    student_img = student_doc.css(student_img_selector).first['src']
    # puts student_img

    student_tagline_selector = "div.two_third h2"
    student_tagline = student_doc.css(student_tagline_selector).first.content
    # puts student_tagline

    student_bio_selector = "div.two_third h2 + p"
    # student_bio = student_doc.css(student_tagline_selector).next_element.content
    student_bio = student_doc.css(student_bio_selector).first.content
    # puts student_bio

    h3_selectors = "div.two_third h3"
    h3_p_selectors = "div.two_third h3 + p"

    # collect about titles in nodeset
    h3_in_about = student_doc.css(h3_selectors)
    # puts h3_in_about
    # puts h3_in_about.class

    # collect about titles in array, without selector
    h3_titles = h3_in_about.collect{|h3| h3.content}
    # puts h3_titles
    # puts h3_titles.class

    ps_in_h3_in_about = student_doc.css(h3_p_selectors)
    # puts ps_in_h3_in_about

    h3_p_content = ps_in_h3_in_about.collect{|p| p.content}
    # puts h3_p_content # this is an array of content

    # alternative to {|p| p.content}
    # h3_p_content = ps_in_h3_in_about.collect(&:content)
    # puts h3_p_content

    # about_student = Hash[*h3_titles.zip(h3_p_content).flatten]

    # # Data Structure
    #   about_student = {
    #     :Aspirations => "text content",
    #     :Interests => "text content"
    #     :social_links ==> [
    #       :globe => "url",
    #       :twitter => "url",
    #       :linkedin => "url"
    #       ]
    #   }

    student_aggregate_array[counter] = {}
    h3_titles.each_with_index do |h3_content, index|
      student_aggregate_array[counter][h3_content.to_sym] = h3_p_content[index]
    end
    # puts about_student

    # blog_link_selector = "i.icon-globe"
    # blog_link = student_doc.css(blog_link_selector).first.parent['href'] if student_doc.css(blog_link_selector).first

    social_links_selector = "div.social_icons i"
    social_link_elements = student_doc.css(social_links_selector)
    # puts social_link_elements

    social_links = []

    # for every i in social links
    social_link_elements.each do |i_element|
      # get the class of the i and strip off the icon-
      link_type = i_element['class'].gsub("icon-", "")
      # then go up to the parent a and get the href
      link_href = i_element.parent['href']
      # puts link_href
      # group those together as a key value pair
      social_links << {link_type.to_sym => link_href}
    end
    # puts social_links

    # add social_links array to about_student hash
    student_aggregate_array[counter][:social_links] = social_links
    # puts about_student

    counter += 1
  rescue
    puts "something went wrong ... ignoring for now"
  end
end

puts student_aggregate_array





######## ITERATE OVER STUDENTS ########

# # Create Nokogiri Document #
#   awesome_student_array = []

#   student_link_array.each do |student|
#     # puts "http://students.flatironschool.com/" + student_link_array[index]

#     begin
#       student_doc = Nokogiri::HTML(open("http://students.flatironschool.com/" + student))
#       puts "http://students.flatironschool.com/" + student

#     rescue
#       puts "http://students.flatironschool.com/" + student + " is not available."
#       puts "Moving on to the next profile."

#     end

#     # creating selectors
#     student_name_selector = "div.two_third h1"
#     student_name = student_doc.css(student_name_selector).first.content 
#     # .text and .content are the same
#     # first picks the first element out of the nodeset (just like picking the first element out of an array)
#     # puts student_name

#     student_img_selector = "section#about div.one_third img"
#     student_img = student_doc.css(student_img_selector).first['src']
#     # puts student_img

#     student_tagline_selector = "div.two_third h2"
#     student_tagline = student_doc.css(student_tagline_selector).first.content
#     # puts student_tagline

#     student_bio_selector = "div.two_third h2 + p"
#     # student_bio = student_doc.css(student_tagline_selector).next_element.content
#     student_bio = student_doc.css(student_bio_selector).first.content
#     # puts student_bio

#     h3_selectors = "div.two_third h3"
#     h3_p_selectors = "div.two_third h3 + p"

#     # collect about titles in nodeset
#     h3_in_about = student_doc.css(h3_selectors)
#     # puts h3_in_about
#     # puts h3_in_about.class

#     # collect about titles in array, without selector
#     h3_titles = h3_in_about.collect{|h3| h3.content}
#     # puts h3_titles
#     # puts h3_titles.class

#     ps_in_h3_in_about = student_doc.css(h3_p_selectors)
#     # puts ps_in_h3_in_about

#     h3_p_content = ps_in_h3_in_about.collect{|p| p.content}
#     # puts h3_p_content # this is an array of content

#     # alternative to {|p| p.content}
#     # h3_p_content = ps_in_h3_in_about.collect(&:content)
#     # puts h3_p_content

#     # about_student = Hash[*h3_titles.zip(h3_p_content).flatten]

#     # # Data Structure
#     #   about_student = {
#     #     :Aspirations => "text content",
#     #     :Interests => "text content"
#     #     :social_links ==> [
#     #       :globe => "url",
#     #       :twitter => "url",
#     #       :linkedin => "url"
#     #       ]
#     #   }


#     about_student = {}
#     h3_titles.each_with_index do |h3_content, index|
#       about_student[h3_content.to_sym] = h3_p_content[index]
#     end
#     # puts about_student

#     # blog_link_selector = "i.icon-globe"
#     # blog_link = student_doc.css(blog_link_selector).first.parent['href'] if student_doc.css(blog_link_selector).first

#     social_links_selector = "div.social_icons i"
#     social_link_elements = student_doc.css(social_links_selector)
#     # puts social_link_elements

#     social_links = []

#     # for every i in social links
#     social_link_elements.each do |i_element|
#       # get the class of the i and strip off the icon-
#       link_type = i_element['class'].gsub("icon-", "")
#       # then go up to the parent a and get the href
#       link_href = i_element.parent['href']
#       # puts link_href
#       # group those together as a key value pair
#       social_links << {link_type.to_sym => link_href}
#     end
#     # puts social_links

#     # add social_links array to about_student hash
#     about_student[:social_links] = social_links
#     # puts about_student

#     # append to awesome_student_array
#     awesome_student_array << about_student
#     puts awesome_student_array
# end