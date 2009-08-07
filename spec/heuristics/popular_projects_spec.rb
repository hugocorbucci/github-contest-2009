require 'lib/heuristics/popular_projects'
require 'lib/project'
require 'lib/user'

describe PopularProjects do
  before(:each) do
    @heuristic = PopularProjects.new(projects, users)
  end
  
  it "should answer the top 10 projects with most followers" do
    @heuristic.select_projects_for(User.new(1)).should == popularity
  end
  
  def popularity
    [4,1,5,2,3]
  end
  
  def users
    users = {}
    20.times { |id| users[id] = User.new(id)}
    (1..5).each do |number_of_followers|
      (4*number_of_followers).times do
        user = users[rand(20)]
        project = create_project(popularity.reverse[number_of_followers-1])
        user.add_project(project)
      end
    end
    users
  end
  
  def projects
    projects = {}
    (1..5).each { |id| projects[id] = create_project(id) }
    projects
  end
  
  def create_project(id)
    Project.new(id, "#{id}", "", Date.today)
  end
end