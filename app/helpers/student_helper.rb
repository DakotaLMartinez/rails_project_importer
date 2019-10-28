module StudentHelper
  def add_button(student)
    return 'N/A' unless student
    if student.added?(current_user)
      link_to('Remove Student', remove_student_path(student), method: :post)
    else
       link_to('Add Student', add_student_path(student), method: :post)
    end
  end
end
