# frozen_string_literal: true

class InvalidRequest < StandardError
  attr_reader :message, :status

  def initialize(message = nil, status = nil)
    @message = message || "Oops... Something Went Wrong!"
    @status = status || :bad_request
  end
end
