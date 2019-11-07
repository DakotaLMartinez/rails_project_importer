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

  def self.import_all 
    data = ProjectImporter.new.fetch
    data.each do |project_hash|
      project = Project.find_by(id: project_hash["id"]) || Project.create(project_hash)
      project.update(status: project_hash["status"]) unless project.status == project_hash["status"]
      project.student_info = project_hash["student_info"] unless project.student
    end
  end

  def student_info=(student_info)
    Batch.find_or_create_by(batch_id: student_info["active_batch_id"])
    self.student = Student.find_or_create_by(student_info)
    self.save
  end

  def student_name 
    student.try(:full_name)
  end

  def short_type 
    TYPES[project_type]
  end

end
