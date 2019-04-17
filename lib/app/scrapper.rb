# descrption de la classe Scrapper
#require 'pry'
require 'nokogiri'
require 'json'
require 'google_drive'

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

  def save_as_spreadsheet(array_to_store)
    # Creates a session with api google
    session = GoogleDrive::Session.from_config("config.json")

    # First worksheet of
    # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("1gTKPrikwno9TQLMFXEDmO1I9cEZEKda4cCvtbSG2wyg").worksheets[0]
    # OK pour moi ws = session.spreadsheet_by_title("test_sh").worksheets.first

    # Changes content of cells.
    # Changes are not sent to the server until you call ws.save().
    array_to_store.each do | row |
      p row
      ws.insert_rows(1,row)
    end
    ws.save
    # Reloads the worksheet to get changes by other clients.
    ws.reload
  end

  def save_as_json(array_to_store)
    File.open("emails.json","w") do |f|
      f.write(JSON.pretty_generate(array_to_store))
    end
    system('mv emails.json db/emails.json')
  end
end
#binding.pry
