class CommitmentCalendar < ActiveRecord::Base
  attr_accessible :calendar_id, :member_id

  belongs_to :member

  def summary
    @summary
  end

  def summary=(summary)
    @summary = summary
  end

end
