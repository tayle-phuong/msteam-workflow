class WorkflowsController < ApplicationController
  before_action :set_workflow, only: %i[ show edit update destroy send_cheer send_survey send_auto]
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_user!, only: [:create]
  before_action :doorkeeper_authorize!, only: [:create]

  # GET /workflows or /workflows.json
  def index
    @workflows = current_user.workflows.order(id: :desc)
  end

  # GET /workflows/1 or /workflows/1.json
  def show
  end

  # GET /workflows/new
  def new
    @workflow = Workflow.new
  end

  # GET /workflows/1/edit
  def edit
  end

  # POST /workflows or /workflows.json
  def create
    @workflow = current_resource_owner.workflows.new(workflow_params)

    if @workflow.save
      render json: @workflow, status: :created
    else
      render json: @workflow.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workflows/1 or /workflows/1.json
  def update
    respond_to do |format|
      if @workflow.update(workflow_params)
        format.html { redirect_to @workflow, notice: "Workflow was successfully updated." }
        format.json { render :show, status: :ok, location: @workflow }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workflows/1 or /workflows/1.json
  def destroy
    @workflow.destroy!

    respond_to do |format|
      format.html { redirect_to workflows_path, status: :see_other, notice: "Workflow was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def send_cheer
    result, success = WorkflowService.new(user: current_user, params:, workflow: @workflow).send_cheer
    flash[success ? :notice : :alert] = result
    redirect_to @workflow
  end

  def send_survey
    result, success = WorkflowService.new(user: current_user, params:, workflow: @workflow).send_survey
    flash[success ? :notice : :alert] = result
    redirect_to @workflow
  end

  def send_auto
    result, success = WorkflowService.new(user: current_user, params:, workflow: @workflow).send_auto
    flash[success ? :notice : :alert] = result
    redirect_to @workflow
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workflow
      @workflow = current_user.workflows.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def workflow_params
      params.require(:workflow).permit(:url, :name)
    end

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
end
