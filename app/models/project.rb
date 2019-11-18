class Project < ApplicationRecord
  belongs_to :student

  TYPES = {
    "CLI Data Gem Portfolio Project" => "CLI",
    "Sinatra Portfolio Project" => "Sinatra",
    "Rails Portfolio Project" => "Rails",
    "Rails with JavaScript Portfolio Project" => "Rails/JS",
    "React Redux Portfolio Project" => "React",
    "CLI" => "CLI Data Gem Portfolio Project",
    "Sinatra" => "Sinatra Portfolio Project",
    "Rails" => "Rails Portfolio Project",
    "Rails/JS" => "Rails with JavaScript Portfolio Project",
    "React" => "React Redux Portfolio Project"
  }

  scope :cli, -> { where(project_type: ["CLI Data Gem Portfolio Project", "CLI Data Gem Project"]) }
  scope :sinatra, -> { where(project_type: ["Sinatra Portfolio Project"]) }
  scope :rails, -> { where(project_type: ["Rails Portfolio Project"]) }
  scope :javascript, -> { where(project_type: ["JavaScript Project Instructions", "JavaScript and Rails Project Instructions", "Rails with JavaScript Portfolio Project", "Rails App with a jQuery Front End"]) }
  scope :final, -> { where(project_type: ["Final Project Requirements","React Redux Portfolio Project", "Rails Angular Portfolio Project"] )}

  def self.import_all 
    data = ProjectImporter.new.fetch
    data.each do |project_hash|
      project = Project.find_by(id: project_hash["id"]) || Project.create(project_hash)
      project.update(status: project_hash["status"]) unless project.status == project_hash["status"]
      project.update(status: project_hash["portfolio_project_id"]) unless project.portfolio_project_id == project_hash["portfolio_project_id"]
      project.student_info = project_hash["student_info"] unless project.student
    end
  end

  def student_info=(student_info)
    Batch.find_or_create_by(batch_id: student_info["active_batch_id"])
    self.student = Student.find_or_create_by(email: student_info["email"])
    self.student.update(student_info) unless student_info.all?{|k,v| self.student.send(k) == v}
    self.save
  end

  def student_name 
    student.try(:full_name)
  end

  def short_type 
    TYPES[project_type]
  end

end
