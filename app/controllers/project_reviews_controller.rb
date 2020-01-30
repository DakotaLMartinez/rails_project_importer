class ProjectReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_review, only: [:show, :edit, :update, :update_status, :destroy]

  # GET /project_reviews
  # GET /project_reviews.json
  def index
    @project_reviews = current_user.project_reviews
  end

  # GET /project_reviews/1
  # GET /project_reviews/1.json
  def show
  end

  # GET /project_reviews/new
  def new
    @project_review = ProjectReview.new
  end

  # GET /project_reviews/1/edit
  def edit
  end

  # POST /project_reviews
  # POST /project_reviews.json
  def create
    @project_review = ProjectReview.new(project_review_params)

    respond_to do |format|
      if @project_review.save
        format.html { redirect_to @project_review, notice: 'Project review was successfully created.' }
        format.json { render :show, status: :created, location: @project_review }
      else
        format.html { render :new }
        format.json { render json: @project_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_reviews/1
  # PATCH/PUT /project_reviews/1.json
  def update
    respond_to do |format|
      if @project_review.update(project_review_params)
        format.html { redirect_to "/project_reviews", notice: 'Project review was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_review }
      else
        format.html { render :edit }
        format.json { render json: @project_review.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_status 
    ProjectImporter.update_status(@project_review.project)
    redirect_to project_reviews_path
  end

  # DELETE /project_reviews/1
  # DELETE /project_reviews/1.json
  def destroy
    @project_review.destroy
    respond_to do |format|
      format.html { redirect_to project_reviews_url, notice: 'Project review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_review
      @project_review = ProjectReview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_review_params
      params.fetch(:project_review).permit(:project_id, :student_id, :notes, :pass, :email_to_student, :action_required)
    end
end
