class WorkflowService
  def initialize(user:, params:, workflow:)
    @user = user
    @params = params
    @workflow = workflow
  end

  def send_cheer
    @body = send_cheer_body.to_json

    send_request

    response
  end

  def send_survey
    @body = send_survey_body.to_json

    send_request

    response
  end

  private

  attr_reader :user, :params, :body, :workflow, :request

  delegate :token, to: :user
  delegate :url, to: :workflow

  def send_request
    @request = Faraday.post(url) do |req|
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

  def send_survey_body
    {
      type: "message",
      flow_type: "survey",
      receivers: [
        {
          email: "lp.wanw@lpwanw.onmicrosoft.com"
        }
      ],
    }
  end

  def response
    return ["Success", true] if request.success?

    [JSON.parse(request.body).with_indifferent_access.dig("error", "message"), false]
  end
end
