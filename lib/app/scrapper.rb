# descrption de la classe Scrapper
#require 'pry'
require 'nokogiri'
require 'json'

class Scrapper
  attr_accessor :page, :scrap_url

  def initialize(scrap_url)
    @page = Nokogiri::HTML(open(scrap_url))  # ici, 'https://www.annuaire-des-mairies.com/'" = scrap_url, dept = "val-d-oise.html"
    @scrap_url = scrap_url
  end

  def get_townhall_email(scrap_url)
      page2 = Nokogiri::HTML(open(scrap_url))
      email = page2.xpath('//main//section[2]//div//table//tbody//tr[4]/td[2]').text
      return email
  end

  def get_townhall_urls
    @page = Nokogiri::HTML(open(scrap_url + "val-d-oise.html"))
    cities = @page.xpath('//*[@class="lientxt"]')
    ary_result = [] # init arrray
      
    cities.each do |city|
        h_cities_email = {} #init hash
        temp = city['href'].delete_prefix('./')
        h_cities_email[city.text] = get_townhall_email("#{scrap_url}#{temp}")
        ary_result << h_cities_email
    end
    return ary_result
  end

  def save_as_csv
    
  end

  def save_as_spreadsheet
    
  end

  def save_as_json(array_to_store)
    File.open("emails.json","w") do |f|
      f.write(JSON.pretty_generate(array_to_store))
    end
    system('mv emails.json db/emails.json')
  end
end
#binding.pry
