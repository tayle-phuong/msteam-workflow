class SubmitController < ActionController::API
  before_action :authenticate_headers!

  def create
    @submit = Submit.new submit_params
    if @submit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_content
    end
  end

  private

  def submit_params
    params.required(:submit).permit(data: {})
  end

  def authenticate_headers!
    @user = User.find_by(email: request.headers['X-Token'])
    return if @user

    render json: {}, status: :unauthorized
  end
end
