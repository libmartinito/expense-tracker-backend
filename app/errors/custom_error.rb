class CustomError < StandardError
  attr_reader :status, :status_code, :title, :detail

  def initialize(status, status_code, title, detail)
    @status = status
    @status_code = status_code
    @title = title
    @detail = detail
  end
end
