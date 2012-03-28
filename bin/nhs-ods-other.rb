require 'rubygems'
require 'net/http'
require 'csv'
require 'json'
require 'hpricot'
require 'open-uri'
require 'zip/zip'

#TODO: epcmem, epracmem
SECTIONS = {
  "genmedpracs" => ["epraccur", "egpcur", "edispensary", "epharmacyhq", "ebranchs"],
  "miscellaneous" => ["egdpprac", "eprison", "ehospice", "espha", "ensa", 
      "etreat", "educate", "eplab", "eother"]
     
}

dir = File.dirname(__FILE__) 

if !File.exists?( File.join(dir, "..", "data") )
  Dir.mkdir( File.join(dir, "..", "data") )
end

SECTIONS.keys.each do |section|
  SECTIONS[section].each do |type|
    
    $stderr.puts("Processing #{section} #{type}")
    #build headers
    $stderr.puts("...building headers")
    headers = []
    page = Hpricot( open("http://www.connectingforhealth.nhs.uk/systemsandservices/data/ods/#{section}/datadefs/#{type}") )
    page.at(".listing").search("tr").each do |row|
      cells = row.search("td")
      if cells.size > 0
        headers << cells[1].inner_text
      end
    end
    $stderr.puts("...reading data")    
    #read data  
    CSV.open( File.join(dir, "..", "data/nhs-ods-#{type}.csv"), "w") do |output|
      output << headers
      url = "http://www.connectingforhealth.nhs.uk/systemsandservices/data/ods/#{section}/datafiles/#{type}.zip"
      temp = Tempfile.new(type)
      temp.write( open(url).read )
      temp.close    
      Zip::ZipFile.open( temp.path ) do |zipfile|
        entry = zipfile.get_entry("#{type}.csv")
        zipfile.get_input_stream(entry) do |stream|
          CSV.parse(stream.read) do |row|
            if row[9].match(/^BA(1|2) /)
              output << row
            end
          end
        end
      end    
    end
    $stderr.puts("OK")
  end  
end

