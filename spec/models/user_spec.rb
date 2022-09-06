# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validate' do
    subject(:user) { build(:user) }

    it { is_expected.to be_valid }
  end

  describe '#first_name' do
    context 'when is invalid' do
      subject(:user) { build(:user, first_name: invalid_first_name) }

      let(:invalid_first_name) { [nil, '', ' '].sample }

      it { is_expected.to be_invalid }
    end
  end

  describe '#last_name' do
    context 'when is invalid' do
      subject(:user) { build(:user, last_name: invalid_last_name) }

      let(:invalid_last_name) { [nil, '', ' '].sample }

      it { is_expected.to be_invalid }
    end
  end

  describe '#email' do
    context 'when is invalid' do
      subject(:user) { build(:user, email: invalid_email) }

      let(:invalid_email) { [nil, '', ' ', 'invalid_email'].sample }

      it { is_expected.to be_invalid }
    end
  end

  describe '#gov_id_number' do
    context 'when is invalid' do
      subject(:user) { build(:user, gov_id_number: invalid_gov_id_number) }

      let(:invalid_gov_id_number) { [nil, '', ' '].sample }

      it { is_expected.to be_invalid }
    end
  end

  describe '#gov_id_type' do
    context 'when is invalid' do
      it do
        expect { build(:user, gov_id_type: 'invalid') }
          .to raise_error ArgumentError
      end
    end

    context 'when is blank' do
      subject(:user) { build(:user, gov_id_type: invalid_gov_id_type) }

      let(:invalid_gov_id_type) { [nil, '', ' '].sample }

      it { is_expected.to be_invalid }
    end
  end

  describe 'uniqueness' do
    context 'when user already exists' do
      subject(:new_user) do
        build(
          :user,
          first_name: existing_user.first_name,
          last_name: existing_user.last_name,
          email: existing_user.email,
          gov_id_number: existing_user.gov_id_number,
          gov_id_type: existing_user.gov_id_type
        )
      end

      let(:existing_user) { create(:user) }

      it { is_expected.to be_invalid }
    end
  end
end
