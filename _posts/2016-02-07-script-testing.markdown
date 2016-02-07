---
layout: post
title: Jekyll Post Script Testing
date:   2016-02-07 01:17:51
categories: ruby
---
The posts here are all done using Jekyll. While I like how light weight it is and the ability to publish using a simple git push, I don't like having to manually name files and put time stamps and metadata on them.

In that spirit I threw together a ruby script to do it for me. This post is just a test to make sure that it's working the way I expected it to. There are two commands.

*.\draft.rb new {filename}*<br />
*.\draft.rb post {blog title} {category tag}*<br />

It creates the appropriate file name and builds the post header information with the arguments passed in at the command line. It's simple and it's stupid, but it's going to save me a lot tedium.
