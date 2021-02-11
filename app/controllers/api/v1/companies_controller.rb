# frozen_string_literal: true

class Api::V1::CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show ]

  def index
    @companies = Company.all

    render json: @companies.select(:id, :name)
  end

  def show
    render json: {
      id: @company.id,
      name: @company.name
    }, status: :ok
  end

  def create
    @company = Company.create!(company_params)

    render json: {
      id: @company.id,
      name: @company.name,
      collaborators: @company.collaborators,
      message: "#{@company.name} has been created"
    }, status: :created
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, collaborators_attributes: [:name, :email])
  end
end
