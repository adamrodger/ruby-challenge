#!/usr/bin/env ruby

require 'optparse'
require 'time'

# Command line parsing
options={}

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: #{__FILE__} --operation OPERATION --time TIME input_file output_file"
	
	opts.on "--operation OPERATION", String, "Operation - 'add' or 'sub'" do |operation|
		options[:operation] = operation
	end
	
	opts.on "--time TIME", "Time to add/subtract in milliseconds" do |time|
		options[:time] = time.sub(",", ".").to_f
	end
	
	opts.on "-v", "--verbose", "Print verbose output" do |verbose|
		options[:verbose] = verbose
	end
end
optparse.parse!

if options[:operation].nil? || options[:time].nil? || ARGV.length != 2
	puts optparse
	exit(-1)
end

options[:input] = ARGV[0]
options[:output] = ARGV[1]

if options[:verbose]
	puts "Running with options:"
	puts "    Operation: #{options[:operation]}"
	puts "    Time:      #{options[:time]}"
	puts "    Input:     #{options[:input]}"
	puts "    Output:    #{options[:output]}"
end

# make time option negative if subtracting
if options[:operation] == "sub"
	options[:time] = -options[:time]
end

# file parsing
timeline = false
separator = " --> "
timeformat = "%H:%M:%S,%L"

File.open(options[:output], 'w') do |output|
	File.open(options[:input], 'r').each do |line|
		if timeline
			# adjust timestamp
			puts "Found time line: #{line}" if options[:verbose]
			dates = line.split(separator)
			startTime = Time.parse(dates[0]) + options[:time]
			endTime = Time.parse(dates[1]) + options[:time]
			output.write "#{startTime.strftime(timeformat)}#{separator}#{endTime.strftime(timeformat)}\n"
		else
			# output a non-time line unchanged
			puts "Found normal line: #{line}" if options[:verbose]
			output.write line
		end
		
		timeline = line =~ /^\d+$/
	end
end