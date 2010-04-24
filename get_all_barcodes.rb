#!/usr/bin/env ruby

require 'set'

barcodes = Set.new

File.open("parksandrec-data/text_extract.txt") do |infile|
  infile.each_line do |line|
    barcodes << $1 if line =~ /(?:^|\s)(4\d\d\d\d\d)(?:\s|$)/
  end
end

barcodes.sort.each do |barcode|
  puts barcode
end
