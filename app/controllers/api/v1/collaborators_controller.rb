# frozen_string_literal: true

class Api::V1::CollaboratorsController < ApplicationController
  before_action :set_collaborator, only: %i[ show update destroy ]
  before_action :set_company, only: %i[ index create ]
  before_action :set_manager, only: %i[ update ]

  rescue_from InvalidRequest, with: :invalid_request

  def index
    @collaborators = @company.collaborators

    render json: @collaborators.select(:id, :name, :email, :company_id, :manager_id)
  end

  def show
    @collaborators = CollaboratorsFinder.call!(
      collaborator: @collaborator,
      collab_info: params[:collab_info]
    )

    if @collaborators.class == Array
      render json: @collaborators.as_json(only: [:id, :name, :email, :company_id, :manager_id])
    else
      render json: @collaborators.select(:id, :name, :email, :company_id, :manager_id)
    end
  end

  def create
    @collaborator = @company.collaborators.create!(collaborator_params)

    render json: {
      id: @collaborator.id,
      name: @collaborator.name,
      email: @collaborator.email,
      manager: @collaborator.manager_id,
      company: @collaborator.company_id,
      message: "#{@collaborator.name} has been created"
    }, status: :created
  end

  def update
    ManagerValidator.call!(collaborator: @collaborator, manager: @manager)
    @collaborator.update!(manager: @manager)

    render json: {
      id: @collaborator.id,
      name: @collaborator.name,
      email: @collaborator.email,
      company_id: @collaborator.company_id,
      manager_id: @collaborator.manager_id
    }
  end

  def destroy
    @collaborator.destroy

    render json: {
      message: "Collaborator has been destroyed"
    }, status: :ok
  end

  private

  def set_collaborator
    @collaborator = Collaborator.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_manager
    @manager = Collaborator.find(params[:manager_id])
  end

  def invalid_request(error)
    render json: { message: error.message }, status: error.status
  end

  def collaborator_params
    params.require(:collaborator).permit(:name, :email)
  end
end
