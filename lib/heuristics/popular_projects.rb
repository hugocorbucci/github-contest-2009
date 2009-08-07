require 'lib/project'
require 'lib/user'

class PopularProjects
  def initialize(projects, users)
    followers = count_followers(users)
    @populars = sort(followers).slice(0..10)
  end
  
  def select_projects_for(user)
    @populars
  end
  
  private
  def count_followers(users)
    follower_counter = {}
    users.values.each do |user|
      user.projects.each do |project|
        if follower_counter[project.id].nil?
          follower_counter[project.id]=0
        else
          follower_counter[project.id]+=1
        end
      end
    end
    follower_counter
  end
  
  def sort(followers)
    followers.sort{|a,b| b[1]<=>a[1]}.map{|tuple| tuple[0]}
  end
end