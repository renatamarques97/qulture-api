# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/api/v1/companies", type: :request do
  include CompaniesSpecHelper
  include ExceptionSpecHelper

  let(:company_name)       { "Company Name" }
  let(:valid_attributes)   { { name: company_name } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET /index" do
    context "when companies are available" do
      let!(:companies) { create_list(:company, 2) }
      let(:expected_body) { index_expected_response(companies) }

      before do
        get api_v1_companies_url, as: :json
      end

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "renders the correct response body" do
        expect(JSON.parse(response.body)).to match(expected_body)
      end
    end

    context "without companies available" do
      before do
        get api_v1_companies_url, as: :json
      end

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "renders the correct response body" do
        expect(JSON.parse(response.body)).to match([])
      end
    end
  end

  describe "GET /show" do
    context "with company available" do
      let(:company) { create(:company) }
      let!(:collaborators) { create_list(:collaborator, 3, company: company) }
      let(:expected_body) { show_expected_response(company, collaborators) }

      before do
        get api_v1_company_url(company), as: :json
      end

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "renders the correct response body" do
        expect(JSON.parse(response.body)).to match(expected_body)
      end
    end

    context "without company available" do
      let(:random_id) { 1 }
      let(:expected_body) do
        exception_body("Couldn't find Company with 'id'=#{random_id}")
      end

      before do
        get api_v1_company_url(random_id), as: :json
      end

      it "renders a successful response" do
        expect(response).to have_http_status(:not_found)
      end

      it "renders the correct response body" do
        expect(JSON.parse(response.body)).to match(expected_body)
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:action) do
        post api_v1_companies_url,
             params: { company: valid_attributes }, as: :json
      end

      context "with nested collaborators" do
        let(:valid_attributes) do
          { name: company_name,
            collaborators_attributes: [
              { name: "Collaborator 1", email: "collab_1@example.com" },
              { name: "Collaborator 2", email: "collab_2@example.com" },
            ]
          }
        end

        it "creates a new Company" do
          expect { action }.to change(Company, :count).by(1)
        end

        it "creates new Collaborators" do
          expect { action }.to change(Collaborator, :count).by(2)
        end

        it "returns the correct status code" do
          action
          expect(response).to have_http_status(:created)
        end

        it "renders a JSON response" do
          action
          expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "renders the created company" do
          action
          expect(response.body).to include("Company Name")
          expect(response.body).to include("Collaborator 1")
          expect(response.body).to include("Collaborator 1")
        end
      end

      context "without nested collaborators" do
        it "creates a new Company" do
          expect { action }.to change(Company, :count).by(1)
        end

        it "does not create new Collaborators" do
          expect { action }.to change(Collaborator, :count).by(0)
        end

        it "returns the correct status code" do
          action
          expect(response).to have_http_status(:created)
        end

        it "renders a JSON response" do
          action
          expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "renders the created company" do
          action
          expect(response.body).to match(a_string_including("Company Name"))
        end
      end
    end

    context "with invalid parameters" do
      let(:action) do
        post api_v1_companies_url,
             params: { company: invalid_attributes }, as: :json
      end

      context "on nested attributes" do
        let(:invalid_attributes) do
          { name: company_name,
            collaborators_attributes: [
              { name: "Collaborator 1", email: "collab_1" },
              { name: "", email: "collab_2@example.com" },
            ]
          }
        end

        let(:expected_body) do
          exception_body("Validation failed: Collaborators email is invalid, Collaborators name can't be blank")
        end

        it "does not create a new Company" do
          expect { action }.to change(Company, :count).by(0)
        end

        it "does not create new Collaborators" do
          expect { action }.to change(Collaborator, :count).by(0)
        end

        it "returns the correct status code" do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "renders a JSON response" do
          action
          expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "renders the error for the new company" do
          action
          expect(JSON.parse(response.body)).to match(expected_body)
        end
      end

      context "on the company data" do
        let(:expected_body) { exception_body("Validation failed: Name can't be blank") }

        it "does not create a new Company" do
          expect { action }.to change(Company, :count).by(0)
        end

        it "returns the correct status code" do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "renders a JSON response" do
          action
          expect(response.content_type).to match(a_string_including("application/json"))
        end

        it "renders the error for the new company" do
          action
          expect(JSON.parse(response.body)).to match(expected_body)
        end
      end
    end
  end
end
