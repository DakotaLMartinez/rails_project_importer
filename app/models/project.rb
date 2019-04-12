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

  def self.fetch_for_batch(batch)
    data = ProjectImporter.new(batch).fetch
    data.each do |project_hash|
      p = Project.create(project_hash)
      puts p.valid?
    end
  end
  
  def student_email=(student_email)
    self.student = Student.find_by(email: student_email)
  end

  def student_name 
    student.full_name
  end

  def short_type 
    TYPES[project_type]
  end

end
