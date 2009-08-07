class User
  include Comparable
    
  attr_reader :id, :projects
  def initialize(id)
    @id=id
    @projects=[]
  end
  
  def add_project(project)
    @projects.push(project)
  end
  
  def <=>(other)
    @id<=>other.id
  end
end