# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_forgery_protection

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_401

  def render_404(error)
    render json: { message: error.message }, status: :not_found
  end

  def render_401(error)
    render json: { message: error.message }, status: :unprocessable_entity
  end
end
