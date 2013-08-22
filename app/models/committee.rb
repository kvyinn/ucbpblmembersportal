# == Schema Information
#
# Table name: committees
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  committee_type_id :integer
#

class Committee < ActiveRecord::Base
  attr_accessible :name

  belongs_to :committee_type

  has_many :committee_members, dependent: :destroy
  has_many :members, through: :committee_members
end
