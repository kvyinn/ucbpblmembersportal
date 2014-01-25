class Post < ActiveRecord::Base
  attr_accessible :title, :edit_tier, :view_tier, :member_id, :content

  def created_by
  	begin
  		member = Member.find(self.member_id)
  		return member
  	rescue
  		return nil
  	end
  end
end
