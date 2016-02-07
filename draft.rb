# draft.rb
#
# simple tool to generate drafts and then push them to post
# mostly used to avoid naming shit and update metadata
#
# post grabs the first thing it can find and moves that
# will not work for managing multiple files
# will automatically grab the first results for post

def BuildPost (args)
  postFile = String.new

  # grab the first .markdown entry in the drafts directory
  files = Dir.entries("_drafts")
  files.each { |file|
    if file.include? ".markdown"
      postFile = file
      break
    end
  }
  # so long as there's a result... do shit.
  unless postFile == ""
    newFile = "_posts/" + Time.now.strftime("%Y-%m-%d-") + postFile
    oldFile = File.read("_drafts/" + postFile)

    File.open(newFile, "w") { |file|
      file.puts "---"
      file.puts "layout: post"
      file.puts "title: #{args[1]}"
      file.puts "date:   #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      file.puts "categories: #{args[2]}"
      file.puts "---"
      file.puts oldFile
    }

    File.delete("_drafts/" + postFile)

  else
    puts "\n\tNo drafts to post."
    puts "\tCreate new draft - draft new {filename}"
  end
end

case ARGV[0]
when "new"
  unless ARGV[1] == nil
    puts "\n\tNew draft created - _drafts/#{ARGV[1]}.markdown"
    File.open("_drafts/#{ARGV[1]}.markdown", "w")
  else
    puts "\n\tdraft new {post title}"
  end

when "post"

  BuildPost(ARGV) unless ARGV.length < 3

else
  puts "\n\tdraft new {post title} - creates a new draft with given title"
  puts "\n\tdraft post - updates and moves draft to posts"

end
puts
