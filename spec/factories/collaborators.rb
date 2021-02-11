# frozen_string_literal: true

FactoryBot.define do
  factory :collaborator do
    name { Faker::Company.name }
    email { Faker::Internet.safe_email }
    company
    manager { nil }
  end
end
