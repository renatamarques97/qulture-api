# frozen_string_literal: true

class Collaborator < ApplicationRecord
  belongs_to :company
  belongs_to :manager, class_name: "Collaborator", optional: true

  has_many :managed, class_name: "Collaborator", dependent: :nullify, foreign_key: "manager_id"

  validates :name, presence: true
  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def node
    return [] unless manager

    managed_by.where.not(id: id)
  end

  private

  def managed_by
    manager.managed
  end
end
