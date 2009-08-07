require 'date'

class Project
  include Comparable
  attr_reader :id, :name, :owner, :since, :forked_from_id

  def self.pattern
    id="\\d+"
    owner="[^\\/]*"
    name="[^,]+"
    since="\\d{4}-\\d{2}-\\d{2}"
    forked_id="\\d+"
    /(#{id}):(#{owner})\/(#{name}),(#{since})(?:,(#{forked_id}))?/
  end
  
  def self.parse(line)
    match = self.pattern.match(line)
    if(match)
      id=match[1].to_i
      owner=match[2]
      name=match[3]
      since=Date.strptime(match[4])
      forked_from_id = match[5].nil? ? nil : match[5].to_i
      return Project.new(id, name, owner, since, forked_from_id)
    end
    return nil
  end
  
  def self.parse_languages(project, line)
    line.split(',').each do |pair|
      language, lines = pair.split(';')
      project.add_language(language.to_sym, lines.to_i)
    end
  end
  
  def initialize(id, name, owner, since, forked_from_id=nil)
    @id=id
    @name=name
    @owner=owner
    @since=since
    @forked_from_id=forked_from_id
    @languages={}
  end
  
  def <=>(other)
    @id <=> other.id
  end
  
  def languages
    @languages.keys.sort {|language, other_language| lines(other_language)<=>lines(language)}
  end
  
  def add_language(language, lines)
    @languages[language] = lines
  end
  
  def lines(language)
    return 0 if @languages[language].nil?
    @languages[language]
  end
end