require 'lib/project_suggester'
require 'lib/user'
require 'lib/project'
require 'date'

describe ProjectSuggester do
  before(:each) do
    user = User.new(1)
    project = Project.new(1,"name","owner",Date.today)
    user.add_project(project)
    @suggester = ProjectSuggester.new({1 => project}, {1 => user})
  end
  
  it "should suggest up to ten projects given a user" do
    @suggester.suggest_projects_for(1).size.should be >= 0
    @suggester.suggest_projects_for(1).size.should be <= 10
  end
  
  it "should suggest up to ten projects even to an unknown user" do
    @suggester.suggest_projects_for(5).size.should be >= 0
    @suggester.suggest_projects_for(5).size.should be <= 10
  end
end