class ApiDocsController < ApplicationController
  skip_before_action :authenticate_request

  def index
    version = params[:version].presence_in(%w[v1]) || raise(ActionController::BadRequest)
    send_file("public/api/#{version}/docs.html", type: "text/html", disposition: "inline")
  end
end
