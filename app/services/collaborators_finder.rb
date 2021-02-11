# frozen_string_literal: true

class CollaboratorsFinder
  ERROR_MESSAGE = "Is not valid"

  attr_reader :collaborator, :collab_info

  def initialize(collaborator, collab_info)
    @collaborator = collaborator
    @collab_info = collab_info
  end

  def self.call!(collaborator:, collab_info:)
    new(collaborator, collab_info).call
  end

  def call
    case collab_info.to_sym
    when :node
      collaborator.node
    when :managed
      collaborator.managed
    when :second_managed
      second_level_managed
    else
      raise InvalidRequest.new(ERROR_MESSAGE, :bad_request)
    end
  end

  private

  def second_level_managed
    query = CollaboratorsQuery.new(collaborator: collaborator)

    query.second_level
  end
end
