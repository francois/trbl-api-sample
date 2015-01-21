require "concepts/show_report/get"
require "representers/errors"
require "representers/show_report"
require "sinatra/base"

begin
  require "debugger"
rescue LoadError => _
  # NOP
end

class Server < Sinatra::Base
  # Returns the list of shows on that date, ordered by interactions_count DESC
  get "/shows/:market_code/:interval/:start_on" do
    result, show_report = ShowReport::Get.run(params)
    if result then
      json Representer::ShowReport.new(show_report)
    else
      errors = show_report.contract.errors.full_messages
      json Representer::Errors.new(OpenStruct.new(code: 400, errors: errors)), 400
    end
  end

  def json(body, code=200)
    [code, {"Content-Type" => "application/json"}, [body.to_json]]
  end
  private :json
end
