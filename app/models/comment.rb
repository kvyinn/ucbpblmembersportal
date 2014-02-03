class Comment < ActiveRecord::Base
  attr_accessible :content, :member_id, :post_id
end
