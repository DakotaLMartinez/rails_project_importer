class StudentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @students = current_user.students
  end

  def add 
    @student = Student.find_by(id: params[:id])
    current_user.students << @student unless current_user.student_ids.include?(params[:id])
    redirect_to request.referrer
  end

  def remove 
    @student = Student.find_by(id: params[:id])
    current_user.students.delete(@student) 
    redirect_to request.referrer
  end
  
  def show 
    @student = Student.find_by(id: params[:id])
    @last_progress_report_row = @student.batch_progress_report_rows.last
  end
end
