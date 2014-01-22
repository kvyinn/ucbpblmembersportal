class Applicant < ActiveRecord::Base
  attr_accessible :description, :image, :name, :preference1, :preference2, :preference3, :deliberation_id, :email
  belongs_to :deliberation
  has_many :applicant_rankings, :foreign_key => :applicant, dependent: :destroy
  has_many :deliberation_assignments, :foreign_key => :applicant, dependent: :destroy
end
