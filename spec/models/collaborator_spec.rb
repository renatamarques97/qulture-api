# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collaborator, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:company) }
  it { is_expected.to have_many(:managed).class_name("Collaborator").dependent(:nullify).with_foreign_key("manager_id") }
  it { is_expected.to belong_to(:manager).class_name("Collaborator").optional }

  describe "email validations" do
    context "when email is the same" do
      before do
        create(:collaborator, email: "sample@email.com")
      end

      it { is_expected.not_to allow_value("sample@email.com").for(:email) }
    end

    context "invalid email format" do
      it { is_expected.not_to allow_value("sampleemail.com").for(:email) }
    end

    context "valid email format" do
      it { is_expected.to allow_value("sample@email.com").for(:email) }
    end
  end

  describe "#node" do
    let(:manager) { create(:collaborator) }

    context "when collaborator has a manager" do
      let(:collaborators) do
        create_list(:collaborator, 3, manager: manager, company: manager.company)
      end

      subject { collaborators.first.node }

      it "returns the correct node" do
        expect(subject).to match([collaborators.second, collaborators.third])
      end
    end

    context "when collaborator does not have a manager" do
      let(:collaborator) { create(:collaborator, manager: nil) }

      subject { collaborator.node }

      it "returns the correct node" do
        expect(subject).to eq([])
      end
    end

    context "when collaborator has a manager without other collaborators managed" do
      let(:collaborator) { create(:collaborator, manager: manager) }

      subject { collaborator.node }

      it "returns the correct node" do
        expect(subject).to eq([])
      end
    end
  end
end
