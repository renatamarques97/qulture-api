# frozen_string_literal: true

module ExceptionSpecHelper
  def exception_body(message)
    {
      message: message
    }.stringify_keys
  end
end
