# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManagerValidator, type: :service do
  describe ".call!" do
    let(:company) { create(:company) }
    let(:collaborator) { create(:collaborator, company: company) }
    let(:manager) { create(:collaborator, company: company) }
    let(:status) { :unprocessable_entity }

    context "when collaborator already has a manager" do
      let(:original_manager) { create(:collaborator, company: company) }
      let(:collaborator) do
        create(:collaborator, company: company, manager: original_manager)
      end

      subject do
        described_class.call!(collaborator: collaborator, manager: manager)
      end

      it "throws an exception with correct attributes" do
        expect { subject }.
          to raise_error(an_instance_of(InvalidRequest))
      end
    end

    context "when manager is not in the same company" do
      let(:manager) { create(:collaborator) }

      subject do
        described_class.call!(collaborator: collaborator, manager: manager)
      end

      it "throws an exception with correct attributes" do
        expect { subject }.
          to raise_error(an_instance_of(InvalidRequest))
      end
    end

    context "when manager is below in the hierarchy" do
      let(:other_collaborator) { create(:collaborator, company: company) }

      before do
        manager.update!(manager: other_collaborator)
        other_collaborator.update!(manager: collaborator)
      end

      subject do
        described_class.call!(collaborator: collaborator, manager: manager)
      end

      it "throws an exception with correct attributes" do
        expect { subject }.
          to raise_error(an_instance_of(InvalidRequest))
      end
    end

    context "when manager is able to manage a collaborator" do
      subject do
        described_class.call!(collaborator: collaborator, manager: manager)
      end

      it "does not throws an exception" do
        expect { subject }.not_to raise_error
      end
    end
  end
end
