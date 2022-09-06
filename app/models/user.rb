# frozen_string_literal: true

class User < ApplicationRecord
  enum :gov_id_type, { drivers_license: 0, passport: 1, social_insurance_number: 2 }, prefix: :with

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :gov_id_number, presence: true, uniqueness: {
    scope: %i[first_name last_name email gov_id_type],
    case_sensitive: false
  }
  validates :gov_id_type, inclusion: { in: gov_id_types }
end
