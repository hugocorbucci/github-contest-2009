require 'lib/project'
require 'date'

describe Project do
  before(:each) do
    @project = Project.new(0,"","",Date.today)
  end
  
  it "should be created with id, name, owner and since" do
    @project.should_not be_nil
  end
  
  it "should know its name" do
    @project.name.should == ""
  end
  
  it "should know its owner's name" do
    @project.owner.should == ""
  end
  
  it "should know its creation date" do
    @project.since.should == Date.today
  end
  
  it "shouldn't have been forked from any project'" do
    @project.forked_from_id.should be_nil
  end
  
  it "should have no languages listed" do
    @project.languages.should == []
  end
  
  it "should have no lines of any language" do
    @project.lines(:C).should == 0
  end
  
  it "should answer its languages and lines" do
    @project.add_language(:C, 666)
    @project.lines(:C).should == 666
  end
  
  describe "when comparing" do
    it "should equal itself" do
      @project.should == @project
    end
    
    it "should equal projects of same id" do
        @project.should == Project.new(0,"","",Date.today)
        @project.should == Project.new(0,"test","",Date.today)
        @project.should == Project.new(0,"","test",Date.today)
        @project.should == Project.new(0,"","",Date.today-1)
        @project.should == Project.new(0,"test","test",Date.today-1)
    end
    
      it "should not equal other ids" do
        @project.should_not == Project.new(1,"","",Date.today)
      end
  end
  
  describe "when forked from some project" do
    before(:each) do
      @forked_project = Project.new(1, "forked", "forker", Date.today-1, @project.id)
    end
    
    it "should be created with id, name, owner and since" do
      @forked_project.should_not be_nil
    end

    it "should know its name" do
      @forked_project.name.should == "forked"
    end

    it "should know its owner's name" do
      @forked_project.owner.should == "forker"
    end

    it "should know its creation date" do
      @forked_project.since.should == Date.today-1
    end

    it "should have been forked from some project with id" do
      @forked_project.forked_from_id.should == @project.id
    end
  end
  
  describe "class" do
    before(:each) do
      @project = Project.parse("1:owner/name,#{Date.today.strftime}")
    end
    
    it "should be able to parse even if the owner is empty" do
      Project.parse("2:/other_name,#{Date.today.strftime}").should_not be_nil
    end
    
    it "should load language data from file into projects" do
      Project.parse_languages(@project, "JavaScript;764,Ruby;1234")
      
      @project.languages.should == [:Ruby, :JavaScript]
      @project.lines(:Ruby).should == 1234
      @project.lines(:JavaScript).should == 764
    end
    
    it "should load language data when have only 1 language" do
      Project.parse_languages(@project, "C;666")

      @project.languages.should == [:C]
      @project.lines(:C).should == 666
    end
    
    it "should load language data when having more than 2 languages" do
      Project.parse_languages(@project, "C;666,JavaScript;764,Ruby;1234")

      @project.languages.should == [:Ruby,:JavaScript,:C]
      @project.lines(:Ruby).should == 1234
      @project.lines(:JavaScript).should == 764
      @project.lines(:C).should == 666
    end
  end
end