class Post < ActiveRecord::Base
  attr_accessible :title, :edit_tier, :view_tier, :member_id, :content
end
