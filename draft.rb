#!/usr/bin/env ruby
#
# draft.rb
#
# simple tool to generate drafts and then push them to post
# mostly used to avoid naming files and updating metadata
#
# rewrite includes support for
#		* list existing drafts
# 		* create a new draft
#		* publish from list of existing drafts

def displayMenu()
	puts
	puts "1. create new"
	puts "2. publish existing"
	puts "3. list existing"
	puts "q.uit"
end

def listFiles()
	files = Dir.entries("_drafts")
	files.delete(".")
	files.delete("..")
	puts
	files.each { |file|
		puts file
	}
end

def newDraft()
	puts
	print "\n\nfilename: "
	filename = gets.chomp

	File.open("_drafts/#{filename}.markdown", "w")
	puts "File created: #{filename}.markdown"
end

def publishPost()
	listFiles
	puts
	print "Filename: "
	postFile = gets.chomp
	postFile += ".markdown"

  if File.exist?("_drafts/#{postFile}")
		# get metadata
		print "Title: "
		postTitle = gets.chomp
		print "Category: "
		postCategory = gets.chomp

		puts
		puts postFile
		puts postTitle
		puts postCategory
		print "\nIs this correct? "
		verify = gets.chomp
		if (verify == "y")
			# write new file
	    newFile = "_posts/" + Time.now.strftime("%Y-%m-%d-") + postFile
	    oldFile = File.read("_drafts/#{postFile}")
	    File.open(newFile, "w") { |file|
	      file.puts "---"
	      file.puts "layout: post"

	      file.puts "title: #{postTitle}"
	      file.puts "date:   #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
	      file.puts "categories: #{postCategory}"
	      file.puts "---"
	      file.puts oldFile
	    }
	    File.delete("_drafts/#{postFile}")
		else
			puts
			puts "aborted move of #{postFile} from draft to post"
		end
  else
    puts "\nInvalid filename -- #{postFile}"
  end
end


running = true

while(running)
	displayMenu
	user_command = gets.chomp

	case user_command
	when "1"
			newDraft
	when "2"
			publishPost
	when "3"
			listFiles
	when "q", "Q"
		running = false
	else
		puts
		puts
	end
end
