# Projet validant : Mairie Christmas

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

def get_townhall_email(townhall_URL)
    page = Nokogiri::HTML(open(townhall_URL))

    email = page.xpath('//main//section[2]//div//table//tbody//tr[4]/td[2]').text
    return email
end

def get_townhall_urls
    page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
    cities = page.xpath('//*[@class="lientxt"]')

    ary_result = [] # init arrray
    
    cities.each do |city|
        h_cities_email = {} #init hash
        temp = city['href'].delete_prefix('./')
        h_cities_email[city.text] = get_townhall_email("http://annuaire-des-mairies.com/#{temp}")
        ary_result << h_cities_email
    end
    return ary_result
end

puts get_townhall_urls