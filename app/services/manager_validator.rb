# frozen_string_literal: true

class ManagerValidator
  ERROR_MESSAGES = {
    has_manager: "Error: Collaborator already has a manager",
    not_in_company: "Error: Couldn't apply because the collaborator is not in the same company",
    hierarchy_below: "Error: Couldn't apply because the collaborator is in a hierarchy below"
  }

  attr_reader :collaborator, :manager

  def initialize(collaborator, manager)
    @collaborator = collaborator
    @manager = manager
  end

  def self.call!(collaborator:, manager:)
    new(collaborator, manager).call
  end

  def call
    collaborator_already_has_manager
    manager_not_in_same_company
    manager_hierarchy_below
  end

  private

  def collaborator_already_has_manager
    raise_exception!(ERROR_MESSAGES[:has_manager]) if collaborator.manager
  end

  def manager_not_in_same_company
    not_same_company = collaborator.company != manager.company

    raise_exception!(ERROR_MESSAGES[:not_in_company]) if not_same_company
  end

  def manager_hierarchy_below
    return if collaborator_managed.empty?

    if second_collaborator_managed.empty? || collaborator_managed.pluck(:id).include?(manager.id)
      raise_exception!(ERROR_MESSAGES[:hierarchy_below])
    end
  end

  def second_collaborator_managed
    collaborators_query.second_level
  end

  def collaborator_managed
    collaborators_query.managed
  end

  def collaborators_query
    @_query ||= CollaboratorsQuery.new(collaborator: collaborator)
  end

  def raise_exception!(message)
    raise InvalidRequest.new(message, :unprocessable_entity)
  end
end
