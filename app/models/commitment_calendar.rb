class CommitmentCalendar < ActiveRecord::Base
  attr_accessible :calendar_id, :member_id, :acl_id, :tag

  belongs_to :member

  def summary
    @summary
  end

  def tag_string
    self.tag ? "tag: #{self.tag}" : "All"
  end

  def summary=(summary)
    @summary = summary
  end

end
