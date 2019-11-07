class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, :set_batch

  def index 
    if @student
      @student.projects
    elsif @batch
      @batch.fetch_projects
      @projects = Project.includes(:student).where(students: {batch: @batch})
    else 
      if Project.last.created_at.in_time_zone < Time.zone.now - 2.hours 
        Project.import_all
        flash[:success] = "New Projects successfully imported"
      end
      @projects = Project.order(created_at: 'desc')
    end
    if params[:type]
      @projects = @projects.where(project_type: Project::TYPES[params[:type]])
    end
  end

  private 

  def set_student 
    @student = params[:student_id] ? Student.find_by(id: params[:student_id]) : nil
  end

  def set_batch 
    @batch = params[:batch_id] ? Batch.find_by(id: params[:batch_id]) : params[:batch_filter_id] ? Batch.find_by(batch_id: params[:batch_filter_id]) : nil
  end

end
