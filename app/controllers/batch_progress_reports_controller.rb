class BatchProgressReportsController < ApplicationController
  before_action :set_batch_progress_report, only: [:show, :edit, :update, :destroy]
  before_action :set_batch

  # GET /batch_progress_reports
  # GET /batch_progress_reports.json
  def index
    @batch_progress_reports = BatchProgressReport.all
  end

  # GET /batch_progress_reports/1
  # GET /batch_progress_reports/1.json
  def show
    # byebug
  end

  # GET /batch_progress_reports/new
  def new
    @batch_progress_report = BatchProgressReport.new
  end

  # GET /batch_progress_reports/1/edit
  def edit
  end

  # POST /batch_progress_reports
  # POST /batch_progress_reports.json
  def create
    @batch_progress_report = BatchProgressReport.new(batch_progress_report_params)

    respond_to do |format|
      if @batch_progress_report.save
        format.html { redirect_to @batch_progress_report, notice: 'Batch progress report was successfully created.' }
        format.json { render :show, status: :created, location: @batch_progress_report }
      else
        format.html { render :new }
        format.json { render json: @batch_progress_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batch_progress_reports/1
  # PATCH/PUT /batch_progress_reports/1.json
  def update
    respond_to do |format|
      if @batch_progress_report.update(batch_progress_report_params)
        format.html { redirect_to [@batch, @batch_progress_report], notice: 'Batch progress report was successfully updated.' }
        format.json { render :show, status: :ok, location: @batch_progress_report }
      else
        format.html { render :edit }
        format.json { render json: @batch_progress_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batch_progress_reports/1
  # DELETE /batch_progress_reports/1.json
  def destroy
    @batch_progress_report.destroy
    respond_to do |format|
      format.html { redirect_to batch_progress_reports_url, notice: 'Batch progress report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch_progress_report
      @batch_progress_report = BatchProgressReport.find(params[:id])
    end
    def set_batch
      @batch = Batch.find(params[:batch_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_progress_report_params
      params.require(:batch_progress_report).permit(:batch_id, :date)
    end
end
