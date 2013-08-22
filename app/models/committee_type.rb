# == Schema Information
#
# Table name: committee_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tier       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CommitteeType < ActiveRecord::Base
  attr_accessible :name, :tier

  has_many :committees
end
