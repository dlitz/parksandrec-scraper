#!/usr/bin/env ruby

def top_level_parse(infile)
  state = :start
  buffer = []
  infile.each_line do |line|
    m = (line =~ /^\s*(?:(Sun?|Mon?|Tue?|Wed?|Thu?|Fri?|Sat?).*)?(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec).*\$.*4\d\d\d\d\d\s*$/)
    buffer << line if state == :start or state == :found
    state = :found if state == :start and m
    if state == :found and line.strip == ""
      yield buffer
      buffer = []
      state = :start
    end
  end
end

def strip_cruft(lines)
  lines = lines.map{|x| x.strip}.join("\n").strip.split("\n")    # Strip a bunch of whitespace
  buffer = []
  blank_count = 0
  lines.each do |line|
    if line.strip == ""
      blank_count += 1
    else
      blank_count = 0
    end
    buffer = [] if blank_count > 0
    buffer << line
  end
  buffer = buffer.map{|x| x.strip}.join("\n").strip.split("\n")    # Strip a bunch of whitespace
  buffer
end

File.open("parksandrec-data/text_extract.txt") do |infile|
  first = true
  top_level_parse(infile) do |lines|
    if first    # Skip the first record -- FIXME: Don't do that
      first = false
      next
    end
    lines = strip_cruft(lines)
    puts lines
    puts "------------"
  end
end

# vim:set tw=0 ts=2 sw=2 sts=2 expandtab:
