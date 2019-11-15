class ProjectReview < ApplicationRecord
  belongs_to :student
  belongs_to :project, optional: true
  belongs_to :user

  scope :not_submitted, ->{ where(project_id: nil)}

  def self.import(user)
    ProjectReviewImporter.fetch.each do |hash|
      student = Student.find_by_full_name(hash[:name]) || Student.find_by_email(hash[:email])
      project = student && student.projects.find_by(project_type: hash[:assessment])
      if student.nil?
        batch = Batch.find_by_iteration(hash[:cohort_name])
        binding.pry unless batch
        student = batch.students.create(full_name: hash[:full_name], github_username: hash[:github_url].match(/github.com\/(.+)\//).try(:[],1), email: hash[:email])
      end
      user.project_reviews.create(student: student, project: project)
    end
  end
end
