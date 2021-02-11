# frozen_string_literal: true

module CollaboratorsSpecHelper
  def collaborator_attributes(collaborator)
    {
      id: collaborator.id,
      name: collaborator.name,
      email: collaborator.email,
      manager_id: collaborator.manager_id,
      company_id: collaborator.company_id
    }.stringify_keys
  end

  def collaborators_expected_response(collaborators)
    collaborators.map do |collaborator|
      collaborator_attributes(collaborator)
    end
  end

  def collaborators_without_company(collaborators)
    collaborators_expected_response(collaborators).map do |collaborator|
      collaborator.except("company_id")
    end
  end
end
