module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from CustomError do |e|
      render json: {
        errors: [
          {
            status: e.status_code,
            title: e.title,
            detail: e.detail
          }
        ]
      }, status: e.status
    end
  end
end
