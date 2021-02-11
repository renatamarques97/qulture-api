# frozen_string_literal: true

require "rails_helper"

RSpec.describe CollaboratorsFinder, type: :service do
  describe ".call!" do
    let(:company) { create(:company) }
    let(:manager) { create(:collaborator, company: company) }

    context "finding node" do
      let(:collaborators) do
        create_list(:collaborator, 3, manager: manager, company: company)
      end

      subject do
        described_class.call!(collaborator: collaborators.first, collab_info: :node)
      end

      before do
        create_list(:collaborator, 2, company: company, manager: collaborators.first)
      end

      it "returns the correct node" do
        expect(subject).to match([collaborators.second, collaborators.third])
      end
    end

    context "finding managed collaborators" do
      let(:collaborators) do
        create_list(:collaborator, 3, manager: manager, company: company)
      end

      subject do
        described_class.call!(collaborator: manager, collab_info: :managed)
      end

      before do
        create_list(:collaborator, 2, company: company, manager: collaborators.first)
      end

      it "returns the correct managed collaborators" do
        expect(subject).to match(collaborators)
      end
    end

    context "finding second level managed collaborators" do
      let(:collaborators) do
        create_list(:collaborator, 3, manager: manager, company: company)
      end

      let(:first_collab_managed) do
        create_list(:collaborator, 2,
                    company: company,
                    manager: collaborators.first)
      end

      let(:second_collab_managed) do
        create_list(:collaborator, 5, company: company, manager: collaborators.second)
      end

      let(:expected_array) { [first_collab_managed, second_collab_managed].flatten }

      subject do
        described_class.call!(collaborator: manager, collab_info: :second_managed)
      end

      before do
        manager.update!(manager: create(:collaborator, company: company))

        create_list(:collaborator, 4, company: company, manager: first_collab_managed.first)

        create_list(:collaborator, 1, company: company, manager: second_collab_managed.first)
      end

      it "returns the correct managed collaborators" do
        expect(subject).to match(expected_array)
      end
    end

    context "with wrong information type" do
      let(:collab_info) { :invalid_type }
      let(:status) { :bad_request }

      subject do
        described_class.call!(collaborator: manager, collab_info: collab_info)
      end

      it "throws an exception with correct attributes" do
        expect { subject }.to raise_error(an_instance_of(InvalidRequest))
      end
    end
  end
end
