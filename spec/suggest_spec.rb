require 'lib/suggest'
require 'lib/project'
require 'lib/user'
require 'date'

describe "Main" do
  it "should return a help message if less than 4 arguments are given" do
    suggest.split("\n").first.should == "usage: suggest repository_file language_file user_file query_file"
    suggest("").split("\n").first.should == "usage: suggest repository_file language_file user_file query_file"
    suggest("","").split("\n").first.should == "usage: suggest repository_file language_file user_file query_file"
    suggest("","","").split("\n").first.should == "usage: suggest repository_file language_file user_file query_file"
  end
  
  it "should run block for each line of the last argument's file" do
    line_count = 0
    suggest('test_repos.txt', 'test_lang.txt', 'test_data.txt', 'test_query.txt') {|line, suggester| line_count+=1}
    line_count.should == 2
  end
  
  it "should return the results of each block evaluation joined by a break line" do
    result = suggest('test_repos.txt', 'test_lang.txt', 'test_data.txt', 'test_query.txt') {|line, suggester| line}
    result.should == "1\n2"
  end
  
  it "should execute the block with each file line" do
    line_count = 0
    load_file('test_data.txt') {|line| line_count+=1}
    line_count.should == 1
    
    line_count = 0
    load_file('test_repos.txt') {|line| line_count+=1}
    line_count.should == 2
  end
  
  it "should create a map for projects from file" do
    loaded_projects = load_projects('test_repos.txt')
    loaded_projects.should == projects
    
    project_attributes_should_match(1, loaded_projects, projects)
    project_attributes_should_match(2, loaded_projects, projects)
  end
  
  it "should create a map for users with projects" do
    loaded_users = load_users('test_data.txt', projects)
    users = {1 => User.new(1)}
    users[1].add_project(projects[1])
    loaded_users.should == users
    
    user_attributes_should_match(1, loaded_users, users)
  end
  
  it "should improve project data given the language file or ignore if project cant be found" do
    loaded = projects
    load_languages('test_lang.txt', loaded)
    
    loaded[1].languages.should == [:Ruby, :JavaScript]
    loaded[1].lines(:Ruby).should == 395056
    loaded[1].lines(:JavaScript).should == 802
    
    loaded[2].languages.should == [:C, :Perl]
    loaded[2].lines(:C).should == 29382
    loaded[2].lines(:Perl).should == 4449
  end
  
  def project_attributes_should_match(id, actuals, expecteds)
    actual = actuals[id]
    expected = expecteds[id]
    actual.name.should == expected.name
    actual.owner.should == expected.owner
    actual.since.should == expected.since
    actual.forked_from_id.should == expected.forked_from_id
  end
  
  def user_attributes_should_match(id, actuals, expecteds)
    actual = actuals[id]
    expected = expecteds[id]
    actual.projects.should == expected.projects
  end
  
  def projects
    return {1 => Project.new(1,"perl-number-compare","richardc",Date.civil(2009,02,26)),
            2 => Project.new(2,"perl-number-sort","hugoc",Date.civil(2009,03,02),1)}
  end
end