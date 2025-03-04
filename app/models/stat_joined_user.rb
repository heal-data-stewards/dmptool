# frozen_string_literal: true

# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  count      :bigint(8)        default(0)
#  date       :date             not null
#  details    :text(65535)
#  filtered   :boolean          default(FALSE)
#  type       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer
#

class StatJoinedUser < Stat
  extend OrgDateRangeable

  class << self

    def to_csv(joined_users)
      Stat.to_csv(joined_users)
    end

  end

end
