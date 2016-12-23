#!/usr/bin/env ruby
#
# draft.rb
#
# simple tool to generate drafts and then push them to post
# mostly used to avoid naming files and updating metadata
#
# post grabs the first thing it can find and moves that
# will not work for managing multiple files
# will automatically grab the first results for post

def BuildPost(args)
  postFile = args[1] + ".markdown"

  if File.exist?("_drafts/#{postFile}")
    newFile = "_posts/" + Time.now.strftime("%Y-%m-%d-") + postFile
    oldFile = File.read("_drafts/#{postFile}")
    File.open(newFile, "w") { |file|
      file.puts "---"
      file.puts "layout: post"
      file.puts "title: #{args[2]}"
      file.puts "date:   #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      file.puts "categories: #{args[3]}"
      file.puts "---"
      file.puts oldFile
    }
    File.delete("_drafts/#{postFile}")
  else
    puts "\n\tNo draft to post names #{postFile}"
    puts "\t create new draft - draft new {filename}"
  end
end

def ListDrafts()
  files = Dir.entries("_drafts")
  files.each { |file|
    puts file unless file == "." || file == ".."
  }
end

case ARGV[0]
when "new"
  unless ARGV[1] == nil
    puts "\n\tNew draft created - _drafts/#{ARGV[1]}.markdown"
    File.open("_drafts/#{ARGV[1]}.markdown", "w")
  else
    puts "\n\tdraft new {filename}"
  end
when "list"
  ListDrafts()
when "post"
  BuildPost(ARGV) unless ARGV.length < 4
else
  puts "\n\tdraft new {filename} - creates a new draft with given title"
  puts "\n\tdraft post {filename} {title} {tag} - updates and moves draft to posts"
end

puts
