# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    gov_id_number { Faker::IDNumber.valid }
    gov_id_type { User.gov_id_types.keys.sample }
  end
end
