require 'rubygems'
require 'rake'
require 'rake/clean'

DATA_DIR="data"

CLEAN.include ["#{DATA_DIR}/*.csv","#{DATA_DIR}/*.json"]

task :weekly do
  sh %{ruby bin/nhs-ods-weekly.rb}
end

task :other do
  sh %{ruby bin/nhs-ods-other.rb}
end

task :download => [:weekly, :other]