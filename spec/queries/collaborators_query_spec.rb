# frozen_string_literal: true

require "rails_helper"

RSpec.describe CollaboratorsQuery, type: :query do
  describe "#managed" do
    let(:company) { create(:company) }
    let(:manager) { create(:collaborator, company: company) }

    let(:collaborators) do
      create_list(:collaborator, 3, manager: manager, company: company)
    end

    let!(:first_collab_managed) do
      create_list(:collaborator, 2, manager: collaborators.first, company: company)
    end

    let!(:second_collab_managed) do
      create_list(:collaborator, 2, manager: collaborators.second, company: company)
    end

    let(:expected_result) do
      [collaborators, first_collab_managed, second_collab_managed].flatten
    end

    subject { described_class.new(collaborator: manager) }

    it "returns all the managed" do
      expect(subject.managed).to match(expected_result)
    end
  end

  describe "#second_level" do
    let(:company) { create(:company) }
    let(:manager) { create(:collaborator, company: company) }

    let(:collaborators) do
      create_list(:collaborator, 3, manager: manager, company: company)
    end

    let!(:first_collab_managed) do
      create_list(:collaborator, 2, manager: collaborators.first, company: company)
    end

    let!(:second_collab_managed) do
      create_list(:collaborator, 2, manager: collaborators.second, company: company)
    end

    let(:expected_result) do
      [first_collab_managed, second_collab_managed].flatten
    end

    subject { described_class.new(collaborator: manager) }

    it "returns all the second level managed" do
      expect(subject.second_level).to match(expected_result)
    end
  end
end
