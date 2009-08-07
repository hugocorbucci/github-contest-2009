#!/usr/bin/env ruby
require 'lib/suggest'

repository_file = ARGV[0]
language_file = ARGV[1]
user_file = ARGV[2]
query_file = ARGV[3]

suggestions = suggest(repository_file, language_file, user_file, query_file) do |line, suggester|
  projects = suggester.suggest_projects_for(line.to_i)
  line + ":" + projects.map{|project| project.id.to_s}.join(',')
end

puts suggestions