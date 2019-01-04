class Senju::Project
  attr_reader :organization, :name

  def self.all
    Senju::Projects.new.data.map do |organization, projects|
      projects.map do |project, connections|
        new(organization, project, connections)
      end
    end.flatten
  end

  def self.first
    all.first
  end

  def initialize(organization, name, connections)
    @organization = organization
    @name = name
    @connections = connections
  end

  def project_with_suffix
    organization + '/' + name
  end

  def issues
    @connections.map do |key, option|
      type, token = Senju::Credential.find(key).to_a.first
      case type
      when "github" then Senju::Github.new(token).issues(project_with_suffix)
      when "gitlab" then Senju::Gitlab.new(token).issues(project_with_suffix)
      end
    end.flatten
  end
end
