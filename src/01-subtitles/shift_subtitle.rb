#!/usr/bin/env ruby

require 'optparse'

# Command line parsing
options={}

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: #{__FILE__} --operation OPERATION --time TIME input_file output_file"
	
	opts.on "--operation OPERATION", String, "Operation - 'add' or 'sub'" do |operation|
		options[:operation] = operation
	end
	
	opts.on "--time TIME", "Time to add/subtract in milliseconds" do |time|
		options[:time] = time.sub(",", "").to_i
	end
end
optparse.parse!

if options[:operation].nil? || options[:time].nil? || ARGV.length != 2
	puts optparse
	exit(-1)
end

puts options

# Time shifting