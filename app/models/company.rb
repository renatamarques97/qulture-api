# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :collaborators, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :collaborators
end
