# frozen_string_literal: true

json.user do
  json.extract! user,
                :first_name, :last_name, :email, :gov_id_number, :gov_id_type
end
