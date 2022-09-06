# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:response_body) { JSON.parse(response.body).deep_symbolize_keys }
  let(:user_keys) do
    %i[first_name last_name email gov_id_number gov_id_type]
  end

  let(:base_user) { create(:user, gov_id_type: User.gov_id_types.keys.first) }
  let(:other_user) { create(:user, User.gov_id_types.keys.last) }

  def set_up_users
    base_user
    # first and last name are the same, the rest is different than both base and other user
    create(:user,
           first_name: base_user.first_name,
           last_name: base_user.last_name,
           gov_id_type: User.gov_id_types.keys.second)
    # email, gov_id_number, and gov_id_type are the same, the rest is different than both base and other user
    create(:user,
           email: base_user.email,
           gov_id_number: base_user.gov_id_number,
           gov_id_type: base_user.gov_id_type)
    other_user
  end

  describe 'GET /users' do
    def make_request
      get(users_path, params:)
    end

    before do
      set_up_users
      make_request
    end

    context 'when no criteria provided' do
      let(:params) { [{}, { unique: true }].sample }

      it :aggregate_failures do
        expect(response).to have_http_status(:bad_request)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when searching by first name - multiple records' do
      let(:params) do
        { user: { first_name: base_user.first_name } }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to be > 1
        expect(response_body[:users].pluck(:first_name))
          .to all(eq params[:user][:first_name])
      end
    end

    context 'when searching by first name - unique record and one result' do
      let(:params) do
        {
          user: { first_name: other_user.first_name },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to eq(1)
        expect(response_body[:users].pluck(:first_name))
          .to all(eq params[:user][:first_name])
      end
    end

    context 'when searching by first name - unique record and multiple results' do
      let(:params) do
        {
          user: { first_name: base_user.first_name },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when searching by last name - multiple records' do
      let(:params) do
        { user: { last_name: base_user.last_name } }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to be > 1
        expect(response_body[:users].pluck(:last_name))
          .to all(eq params[:user][:last_name])
      end
    end

    context 'when searching by last name - unique record and one result' do
      let(:params) do
        {
          user: { last_name: other_user.last_name },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to eq(1)
        expect(response_body[:users].pluck(:last_name))
          .to all(eq params[:user][:last_name])
      end
    end

    context 'when searching by last name - unique record and multiple results' do
      let(:params) do
        {
          user: { last_name: base_user.last_name },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when searching by email - multiple records' do
      let(:params) do
        { user: { email: base_user.email } }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to be > 1
        expect(response_body[:users].pluck(:email))
          .to all(eq params[:user][:email])
      end
    end

    context 'when searching by email - unique record and one result' do
      let(:params) do
        {
          user: { email: other_user.email },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to eq(1)
        expect(response_body[:users].pluck(:email))
          .to all(eq params[:user][:email])
      end
    end

    context 'when searching by email - unique record and multiple results' do
      let(:params) do
        {
          user: { email: base_user.email },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when searching by gov id number - multiple records' do
      let(:params) do
        { user: { gov_id_number: base_user.gov_id_number } }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to be > 1
        expect(response_body[:users].pluck(:gov_id_number))
          .to all(eq params[:user][:gov_id_number])
      end
    end

    context 'when searching by gov id number - unique record and one result' do
      let(:params) do
        {
          user: { gov_id_number: other_user.gov_id_number },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to eq(1)
        expect(response_body[:users].pluck(:gov_id_number))
          .to all(eq params[:user][:gov_id_number])
      end
    end

    context 'when searching by gov id number - unique record and multiple results' do
      let(:params) do
        {
          user: { gov_id_number: base_user.gov_id_number },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when searching by gov id type - multiple records' do
      let(:params) do
        { user: { gov_id_type: base_user.gov_id_type } }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to be > 1
        expect(response_body[:users].pluck(:gov_id_type))
          .to all(eq params[:user][:gov_id_type])
      end
    end

    context 'when searching by gov id type - unique record and one result' do
      let(:params) do
        {
          user: { gov_id_type: other_user.gov_id_type },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to eq(1)
        expect(response_body[:users].pluck(:gov_id_type))
          .to all(eq params[:user][:gov_id_type])
      end
    end

    context 'when searching by gov id type - unique record and multiple results' do
      let(:params) do
        {
          user: { gov_id_type: base_user.gov_id_type },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when searching by multiple criteria - multiple records' do
      let(:params) do
        {
          user: {
            email: base_user.email,
            gov_id_number: base_user.gov_id_number
          }
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to be > 1
        expect(response_body[:users].pluck(:email))
          .to all(eq params[:user][:email])
        expect(response_body[:users].pluck(:gov_id_number))
          .to all(eq params[:user][:gov_id_number])
      end
    end

    context 'when searching by multiple criteria - unique record and one result' do
      let(:params) do
        {
          user: {
            email: other_user.email,
            gov_id_number: other_user.gov_id_number
          },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:users].size).to be < User.count
        expect(response_body[:users].size).to eq(1)
        expect(response_body[:users].pluck(:email))
          .to all(eq params[:user][:email])
        expect(response_body[:users].pluck(:gov_id_number))
          .to all(eq params[:user][:gov_id_number])
      end
    end

    context 'when searching by multiple criteria - unique record and multiple results' do
      let(:params) do
        {
          user: {
            email: base_user.email,
            gov_id_number: base_user.gov_id_number
          },
          unique: true
        }
      end

      it :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response_body[:errors]).to be_present
      end
    end
  end

  describe 'POST /users' do
    def make_request
      post(users_path, params: { user: params })
    end

    let(:params) { attributes_for(:user) }

    context 'with valid params' do
      it :aggregate_failures do
        expect { make_request }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response_body[:user].keys).to match_array(user_keys)
      end
    end

    context 'with invalid params' do
      let(:params) { { foo: 'bar' } }

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:errors]).not_to be_empty
      end
    end
  end

  describe 'DELETE /users' do
    def make_request
      delete(users_path, params:)
    end

    before { set_up_users }

    context 'when no criteria provided' do
      let(:params) { [{}, { unique: true }].sample }

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:bad_request)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when deleting by first name - multiple results' do
      let(:params) do
        { user: { first_name: base_user.first_name } }
      end

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when deleting by first name - one result' do
      let(:params) do
        { user: { first_name: other_user.first_name } }
      end

      it :aggregate_failures do
        expect { make_request }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end

    context 'when deleting by last name - multiple results' do
      let(:params) do
        { user: { last_name: base_user.last_name } }
      end

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when deleting by last name - one result' do
      let(:params) do
        { user: { last_name: other_user.last_name } }
      end

      it :aggregate_failures do
        expect { make_request }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end

    context 'when deleting by email - multiple results' do
      let(:params) do
        { user: { email: base_user.email } }
      end

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when deleting by email - one result' do
      let(:params) do
        { user: { email: other_user.email } }
      end

      it :aggregate_failures do
        expect { make_request }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end

    context 'when deleting by gov id number - multiple results' do
      let(:params) do
        { user: { gov_id_number: base_user.gov_id_number } }
      end

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when deleting by gov id number - one result' do
      let(:params) do
        { user: { gov_id_number: other_user.gov_id_number } }
      end

      it :aggregate_failures do
        expect { make_request }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end

    context 'when deleting by gov id type - multiple results' do
      let(:params) do
        { user: { gov_id_type: base_user.gov_id_type } }
      end

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when deleting by gov id type - one result' do
      let(:params) do
        { user: { gov_id_type: other_user.gov_id_type } }
      end

      it :aggregate_failures do
        expect { make_request }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end

    context 'when deleting by multiple criteria - multiple results' do
      let(:params) do
        {
          user: {
            email: base_user.email,
            gov_id_number: base_user.gov_id_number
          }
        }
      end

      it :aggregate_failures do
        expect { make_request }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body[:errors]).to be_present
      end
    end

    context 'when deleting by multiple criteria - one result' do
      let(:params) do
        {
          user: {
            email: other_user.email,
            gov_id_number: other_user.gov_id_number
          }
        }
      end

      it :aggregate_failures do
        expect { make_request }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end
  end
end
