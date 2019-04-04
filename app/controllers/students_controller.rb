class StudentsController < ApplicationController
  before_action :authenticate_user!
  def add 
    @student = Student.find_by(id: params[:id])
    current_user.students << @student unless current_user.student_ids.include?(params[:id])
    redirect_to request.referrer
  end

  def remove 
    @student = Student.find_by(id: params[:id])
    current_user.student.delete(@student) 
    redirect_to request.referrer
  end
end
