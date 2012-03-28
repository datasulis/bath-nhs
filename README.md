BATH NHS ORGANISATIONS
----------------------

Scripts to extract data from the [NHS Organisational Data Service][1] to grab data about 
NHS and related medical care providers in the Bath Area.

INSTALL
-------

The project has very simple dependencies relying on core libraries plus the Hpricot, RubyZip and 
JSON gems:

	sudo gem install json
	sudo gem install hpricot
	sudo gem install rubyzip
	
USAGE
-----

To download and cache all the relevant files run:

	rake download
	
To grab just the data that is updated weekly by the ODS run:

	rake weekly
	
To grab all of the other additional data, e.g. GP Practices, Pharmacies, Treatment Centres etc run:

	rake other

The data is all stored in the data sub-directory of the project.

Currently all the scripts do is filter the published files to grab just those NHS Organisations with 
Bath (BA1, BA2) postcodes.

[1]: http://www.connectingforhealth.nhs.uk/systemsandservices/data/ods