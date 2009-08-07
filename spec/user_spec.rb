require 'lib/user'
require 'lib/project'
require 'date'

describe User do
  before(:each) do
    @user = User.new(0)
  end

  it "should be created with ID" do
    lambda{User.new(0)}.should_not raise_error
  end
  
  it "should have an empty list of projects when new" do
    @user.projects.should == []
  end
  
  it "should add a project to the list" do
    project = Project.new(1,"name","owner", Date.today)
    @user.add_project(project)
    @user.projects.should == [project]
  end
  
  describe "when comparing" do
    it "should equal itself" do
      @user.should == @user
    end
    
    it "should equal user of same id" do
        @user.should == User.new(0)
    end
    
    it "should not equal other ids" do
      @user.should_not == User.new(1)
    end
  end
end