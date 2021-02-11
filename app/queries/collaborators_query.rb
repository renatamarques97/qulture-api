# frozen_string_literal: true

class CollaboratorsQuery
  def initialize(collaborator:)
    @collaborator = collaborator
  end

  def managed
    first_level + second_level
  end

  def second_level
    @second_level ||= first_level.flat_map { |c| c.managed } || []
  end

  private

  def first_level
    @_first_level ||= @collaborator.managed
  end
end
