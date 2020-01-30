class ProjectReview < ApplicationRecord
  belongs_to :student
  belongs_to :project, optional: true
  belongs_to :user

  scope :not_submitted, ->{ where(project_id: nil) }

  def self.import(user)
    ProjectReviewImporter.fetch.each do |hash|
      student = Student.find_by_full_name(hash[:name]) || Student.find_by_email(hash[:email])
      project = Project.find_by_github_url(hash[:github_url])
      if student.nil?
        batch = Batch.find_by_iteration(hash[:cohort_name])
        binding.pry unless batch
        student = batch.students.create(full_name: hash[:full_name], github_username: hash[:github_url].match(/github.com\/(.+)\//).try(:[],1), email: hash[:email])
      end
      review = user.project_reviews.find_or_create_by(name: hash[:name], email: hash[:email], date: hash[:date], github_url: hash[:github_url], cohort_name: hash[:cohort_name], learn_profile_url: hash[:learn_profile_url], assessment: hash[:assessment])
      review.student = student 
      review.project = project
      review.save
    end
  end

  # def self.update
  #   self.all.each do |pr|
      
  #   end
  # end
end
