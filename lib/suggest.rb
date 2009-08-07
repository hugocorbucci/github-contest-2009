require 'lib/project'
require 'lib/user'
require 'lib/project_suggester'

def suggest(repository_file=nil, language_file=nil, user_file=nil, query_file=nil)
  return help unless repository_file and language_file and user_file and query_file
  
  projects = load_projects(repository_file)
  load_languages(language_file, projects)
  users = load_users(user_file, projects)
  suggester = ProjectSuggester.new(projects, users)
  
  result = []
  load_file(query_file) {|line| result.push(yield(line, suggester))}
  result.join("\n")
end

def help
  "usage: #{File.basename(__FILE__, '.rb')} repository_file language_file user_file query_file

You must specify each filepath with:
  repository_file\tProjects database: each line describes a project.
\t\t\tPattern: /PROJECT_ID:OWNER_NAME/PROJECT_NAME,YYYY-MM-DD/
\t\t\tExample: 1:richardc/perl-number-compare,2009-02-26
  language_file\t\tLanguage database: each line describes project languages
\t\t\tPattern: /PROJECT_ID:LANGUAGE_NAME;LINES_OF_CODE(,LANGUAGE_NAME;LINES_OF_CODE)*/
\t\t\tExample: 1:JavaScript;802,Ruby;395056
  user_file\t\tUser database: each line describes an association between a user and a project
\t\t\tPattern: /USER_ID:PROJECT_ID/
\t\t\tExample: 1:3
  query_file\t\tQuery databse: each line shows a user for which we want at most 10 project suggestions
\t\t\tPattern /USER_ID/
\t\t\tExample: 1"
end

def load_projects(repository_file)
  projects = {}
  load_file(repository_file) do |project_line|
    project = Project.parse(project_line)
    projects[project.id]=project
  end
  projects
end

def load_users(user_file, projects)
  users = {}
  load_file(user_file) do |user_line|
    user_id,project_id = user_line.split(':').map{|value| value.to_i}
    users[user_id] = User.new(user_id.to_i) if users[user_id].nil?
    users[user_id].add_project(projects[project_id])
  end
  users
end

def load_languages(language_file, projects)
  load_file(language_file) do |language_line|
    project_id, languages = language_line.split(':')
    project = projects[project_id.to_i]
    Project.parse_languages(project, languages) unless project.nil?
  end
end

def load_file(file_path)
  file = File.new(file_path)
  while(line = file.gets) do
    yield line.strip
  end
end
