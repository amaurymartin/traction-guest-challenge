# frozen_string_literal: true

class UsersController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

  before_action :set_users_by_criteria, only: %i[index destroy]

  def index
    if search_params[:unique] && @users.many?
      render json: { errors: 'More than one record found for the given criteria' },
             status: :ok
    else
      render :index, locals: { users: @users }, status: :ok
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render :show, locals: { user: @user }, status: :created
    else
      render :errors, locals: { user: @user }, status: :unprocessable_entity
    end
  end

  def destroy
    if @users.one? && @users.destroy_all
      head :no_content
    else
      render json: { errors: 'Unable to delete, more than one record found for the given criteria' },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      %i[first_name last_name email gov_id_number gov_id_type]
    )
  end

  def search_params
    params.permit(:unique)
  end

  def set_users_by_criteria
    @users = User.where(**user_params)
  end

  def handle_parameter_missing(exception)
    render json: { errors: exception.message }, status: :bad_request
  end
end
