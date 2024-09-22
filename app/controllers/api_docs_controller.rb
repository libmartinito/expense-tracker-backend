class ApiDocsController < ApplicationController
  def index
    version = params[:version].presence_in(%w[v1]) || raise(ActionController::BadRequest)
    render file: "public/api/#{version}/docs.html"
  end
end
