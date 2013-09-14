# == Schema Information
#
# Table name: members
#
#  id             :integer          not null, primary key
#  provider       :string(255)
#  uid            :string(255)
#  name           :string(255)
#  remember_token :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Member < ActiveRecord::Base
  attr_accessible :name

  validates :provider, :uid, :name, presence: true

  before_create :create_remember_token

  has_many :tabling_slot_members, dependent: :destroy
  has_many :tabling_slots, through: :tabling_slot_members

  has_many :committee_members, dependent: :destroy
  has_many :committees, through: :committee_members

  has_many :commitment_calendars, dependent: :destroy

  has_many :event_members, dependent: :destroy

  has_many :reimbursements, dependent: :destroy

  has_many :commitments, dependent: :destroy

  def position(committee=nil)
    committee = self.committees.first if !committee
    if committee
      committee_member = self.committee_members.where(
        committee_id: committee.id
      ).first

      committee_member.committee_member_type.name if committee_member
    end
  end

  def tier(committee=nil)
    committee = self.committees.first if !committee
    if committee
      committee_member = self.committee_members.where(
        committee_id: committee.id
      ).first

      committee_member.committee_member_type.tier if committee_member
    end
  end

  def admin?
    self.name == "Keien Ohta" or self.committees.include?(Committee.where(name: "Executive").first)
  end

  def officer?
    self.admin? or
    self.position == "chair"
  end

  def tabling_slot_member(tabling_slot)
    self.tabling_slot_members.where(tabling_slot_id: tabling_slot.id).first
  end

  def self.initialize_with_omniauth(provider, uid)
    Member.where(provider: provider, uid: uid).first_or_initialize
  end

  def cms
    self.committees.map do |committee|
      committee.members
    end.flatten
  end

  def Member.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Member.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def attended?(event)
    !self.event_members.where(event_id: event.id).empty?
  end

  def autocomplete_display
    committee_name = self.committees.first ? self.committees.first.name : "N/A"

    "#{self.name}; #{committee_name}: #{self.position || "Member"}"
  end

  private

    def create_remember_token
      self.remember_token = Member.encrypt(Member.new_remember_token)
    end
end
