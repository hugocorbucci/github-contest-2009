require 'lib/project'
require 'lib/user'
require 'lib/heuristics'

class ProjectSuggester
  def initialize(projects, users)
    @projects = projects
    @users = users
    @heuristic = PopularProjects.new(@projects,@users)
  end
  
  def suggest_projects_for(user_id)
    @heuristic.select_projects_for(user_id)
  end
end
