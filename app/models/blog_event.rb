class BlogEvent < ActiveRecord::Base
  attr_accessible :post_id, :event_id
  belongs_to :post
  belongs_to :event
end
