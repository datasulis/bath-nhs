require 'rubygems'
require 'net/http'
require 'csv'
require 'json'

TYPES={
  "ro" => "Regional Directorate",
  "ha" => "Strategic Health Authority",
  "tr" => "NHS Trust",
 "ts" => "NHS Trust Site",
  "pt" => "Primary Care Trust",
  "pu" => "Primary Care Trust Site",
  "ct" => "Care Trust",
  "cu" => "Care Trust Site",
  "ph" => "Independent Health Care Provider",
  "pp" => "Independent Health Care Provider Site",
  "ip" => "Non NHS Organisation"  
}

#Standard Headers from ODS, prepended with a "type" header
HEADERS = [
  "Organisation Type",
  "Organisation Code",
  "Organisation Name",
  "IT Cluster",
  "SHA code",
  "Address Line 1",  
  "Address Line 2",
  "Address Line 3",
  "Address Line 4",
  "Address Line 5",
  "Postcode",
  "Open Date",
  "Close Date"
]

dir = File.dirname(__FILE__) 

if !File.exists?( File.join(dir, "..", "data") )
  Dir.mkdir( File.join(dir, "..", "data") )
end

CSV.open( File.join(dir, "..", "data/nhs-ods-weekly.csv"), "w") do |output|
  output << HEADERS
  TYPES.keys.each do |type|    
    Net::HTTP.start('www.connectingforhealth.nhs.uk') do |http|
      req = Net::HTTP::Get.new("/systemsandservices/data/ods/datafiles/#{type}.csv") 
      response = http.request(req)
      CSV.parse( response.body ) do |row|
        if row[9].match(/^BA(1|2) /)
          output << [ TYPES[type] ] + row
        end
      end
    end    
  end
end  