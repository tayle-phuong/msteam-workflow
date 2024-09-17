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

  def send_auto
    @body = send_auto_body.to_json

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
          submit_url: "#{ENV["HOST_URL"]}/submit",
          email: "lp.wanw@lpwanw.onmicrosoft.com"
        }
      ],
    }
  end

  def send_auto_body
    {
      type: "message",
      flow_type: "auto",
      items: [
        {
          recipient: "lp.wanw@lpwanw.onmicrosoft.com",
          queries: {
            my_id: "my_id",
          },
          headers: {
            "X-Token": "lp.wanw@lpwanw.onmicrosoft.com",
          },
          submit_url: "#{ENV["HOST_URL"]}/submit",
          question: params[:question],
          message: {
            type: "AdaptiveCard",
            body: [
              {
                "type": "TextBlock",
                "size": "Medium",
                "weight": "Bolder",
                "text": "You have received a Survey!"
              },
              {
                "type": "TextBlock",
                "text": params[:question],
                "wrap": true
              },
              {
                "type": "ColumnSet",
                "columns": [
                  {
                    "type": "Column",
                    "width": "stretch",
                    "items": [
                      {
                        "id": "answer1",
                        "type": "Input.ChoiceSet",
                        "choices": [
                          {
                            "title": "1",
                            "value": "1"
                          },
                          {
                            "title": "2",
                            "value": "2"
                          },
                          {
                            "title": "3",
                            "value": "3"
                          },
                          {
                            "title": "4",
                            "value": "4"
                          },
                          {
                            "title": "5",
                            "value": "5"
                          }
                        ],
                        "placeholder": "Placeholder text"
                      }
                    ]
                  }
                ]
              },
              {
                "type": "TextBlock",
                "text": params[:question],
                "wrap": true
              },
              {
                "type": "ColumnSet",
                "columns": [
                  {
                    "type": "Column",
                    "width": "stretch",
                    "items": [
                      {
                        "id": "answer2",
                        "type": "Input.ChoiceSet",
                        "choices": [
                          {
                            "title": "1",
                            "value": "1"
                          },
                          {
                            "title": "2",
                            "value": "2"
                          },
                          {
                            "title": "3",
                            "value": "3"
                          },
                          {
                            "title": "4",
                            "value": "4"
                          },
                          {
                            "title": "5",
                            "value": "5"
                          }
                        ],
                        "placeholder": "Placeholder text"
                      }
                    ]
                  }
                ]
              }
            ],
            "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
            "version": "1.4",
            "actions": [
              {
                "type": "Action.Submit",
                "title": "Choose"
              }
            ]
          }
        }
      ]
    }
  end

  def response
    return ["Success", true] if request.success?

    [JSON.parse(request.body).with_indifferent_access.dig("error", "message"), false]
  end
end
