require 'open-uri'
require 'nokogiri'
require 'pp'

url = "http://students.flatironschool.com"

doc = Nokogiri::HTML(open("#{url}"))

profile = {}

profile_link_url = doc.css("div.one_third a").map { |link| link['href']}

profile_link_url.each do |partial_name_url|
partial_name_url = partial_name_url.to_sym
profile[partial_name_url] ||= {}
end

profile.each do |partial_name_url, profile_contents|
full_url = url + "/" + partial_name_url.to_s
  # puts full_url
  begin

profile_doc = Nokogiri::HTML(open("#{full_url}")) 

    h1_selector = "div.two_third.last h1"
    h1 = profile_doc.css(h1_selector)

    h1.each do |h1|
      h1_text = h1.content
      profile[partial_name_url][:name] = h1_text
    end

    bio_selector = "div.two_third.last h2 + p"
    bio = profile_doc.css(bio_selector)

    bio.each do |p|
      bio_text = p.content
      profile[partial_name_url][:bio] = bio_text
    end

    p_aspirations = profile_doc.css("div.two_third.last h3:nth-child(4) + p")

    profile[partial_name_url][:aspirations] = p_aspirations.text

    p_interests = profile_doc.css("div.two_third.last h3:nth-child(6) + p")

    profile[partial_name_url][:interests] = p_interests.text

    # social_links = profile_doc.css("div.social_icons li a").map { |link| link['href']}
    # profile[partial_name_url][:social_media_links] = social_links

    social_link_elements = profile_doc.css("div.social_icons i")
   
    profile[partial_name_url][:social_media_links] = {}

    social_link_elements.each do |i_element|
      link_type = i_element['class'].gsub("icon-","")
      link_href = i_element.parent['href']
      profile[partial_name_url][:social_media_links][link_type.to_sym] = link_href
    end

    work = profile_doc.css("section#former_life div.one_half:first-child ul.check_style")

    work.each do |li|
      work_text = li.content
      profile[partial_name_url][:work] = work_text
    end

    education = profile_doc.css("section#former_life div.one_half.last ul.check_style")

    education.each do |li|
      education_text = li.content
      profile[partial_name_url][:education] = education_text
    end

    coder_links = profile_doc.css("div.coder_cred td a:first-child").map { |link| link['href']}
    profile[partial_name_url][:coder_links] = coder_links

    # fav_selectors = profile_doc.css("section#favorites div.center h3")
    # fav_selectors.each do |node_element|
    #   fav_text = (node_element.children.text.to_sym)
    #   profile[partial_name_url][fav_text] = []
    # end

    # fav_name_selectors = profile_doc.css("section#favorites div.center div.columns div.one_third figure.img_left figcaption")
    # fav_name_selectors.each do |node_element|
    #   fav_name_text = node_element.children.text
    #   profile[partial_name_url][fav_text] << fav_name_text
    # end

    misc_quote = profile_doc.css("div.one_fourth")
    profile[partial_name_url][:misc] = misc_quote.text

  rescue
  
  end
end

pp profile


# to grab content from misc... 
# key: h2 value: whatever <p> and <q> in that section 

# ----------------------------

# grab all the unique <a> tags from section id = about on students.flatironschool.com
# for each link, open link
    # do individual page loop
# grab info we want from profile: name, bio, aspirations, interests, social media links
# add each student's profile info into a hash
   # site = { 
        # :anabecker.html => {
                              # :name => ana_becker
                              # :bio =>
                              # :aspirations =>
                              # :interests =>
                              # :social_media_links => []
                              # :work =>
                              # :education =>
                              # :misc => }
# all selectors in section id = about
# person's name => h1
# bio => h2 + p


# h3s = doc/"div.two_third.last h3"

# h3s.each do |e| 
# htest = e.content
#   puts htest
#   end

# ps = doc/"div.two_third.last h3 + p"

# ---------------------

# "test".sub("test", "") => "t"
# "test".delete("te") => "st"
# "test".chomp => only removes from the end of the string

