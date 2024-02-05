#!/bin/crystal
require "./config/*"
require "sam"
require "./db/migrations/*"
require "system"

load_dependencies "jennifer"

# Here you can define your tasks
# desc "with description to be used by help command"
# task "test" do
#   puts "ping"
# end
# 

# task "start" do
#     system "crystal run src/rm_api.cr"
# end

Sam.help
