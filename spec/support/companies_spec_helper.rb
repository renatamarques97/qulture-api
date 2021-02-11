# frozen_string_literal: true

module CompaniesSpecHelper
  include CollaboratorsSpecHelper

  def company_attributes(company)
    {
      id: company.id,
      name: company.name
    }.stringify_keys
  end

  def index_expected_response(companies)
    companies.map do |company|
      company_attributes(company)
    end
  end

  def show_expected_response(company, collaborators = [])
    json = company_attributes(company)
    json
  end
end
