class ApiDocsController < ApplicationController
  def index
    version = params[:version]
    render file: "public/api/#{version}/docs.html"
  end
end
