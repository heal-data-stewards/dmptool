# frozen_string_literal: true

# == Schema Information
#
# Table name: token_permission_types
#
#  id               :integer          not null, primary key
#  text_description :text(65535)
#  token_type       :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

FactoryBot.define do
  factory :token_permission_type do
    token_type { Faker::Lorem.word }
    text_description { Faker::Lorem.sentence }
  end
end
