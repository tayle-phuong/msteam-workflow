class WorkflowService
  def initialize(user:, params:, workflow:)
    @user = user
    @params = params
    @workflow = workflow
  end

  def send_cheer
    @body = send_cheer_body.to_json
    Rails.logger.info send_request
  end

  private

  attr_reader :user, :params, :body, :workflow

  delegate :token, to: :user
  delegate :url, to: :workflow

  def send_request
    Faraday.post(url) do |req|
      req.params['api-version'] = "2016-06-01"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{token}"
      req.body = body
    end
  end

  def send_cheer_body
    {
      type: "message",
      flow_type: "cheer",
      message: "#{params[:to]} received a Cheer from #{params[:from]}"
    }
  end
end
