# == Schema Information
#
# Table name: commitment_calendars
#
#  id          :integer          not null, primary key
#  member_id   :integer
#  calendar_id :string(255)
#  acl_id      :string(255)
#  tag         :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# == Description
#
# A calender from which commitments are scanned.
#
# == Fields
# - calendar_id: reference to the calendar
# - acl_id: permissions for the calendar (currently not working)
# - tag: the tag to look for in this calendar
#
# == Associations
#
# === Belongs to
# - Member
class CommitmentCalendar < ActiveRecord::Base
  attr_accessible :calendar_id, :member_id, :acl_id, :tag

  belongs_to :member

  # Set the description for this calendar, for displaying in the views
  def summary
    @summary
  end

  # Tag display helper for views
  def tag_string
    self.tag ? "tag: #{self.tag}" : "All"
  end

end
