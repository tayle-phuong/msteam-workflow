class SubmitsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_submit, only: %i[ show destroy ]

  # GET /submits or /submits.json
  def index
    @submits = Submit.all.order(id: :desc)
  end

  # GET /submits/1 or /submits/1.json
  def show
  end

  # DELETE /submits/1 or /submits/1.json
  def destroy
    @submit.destroy!

    respond_to do |format|
      format.html { redirect_to submits_path, status: :see_other, notice: "Submit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submit
      @submit = Submit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submit_params
      params.require(:submit).permit(:data)
    end
end
