class PostCategory < ActiveRecord::Base
  attr_accessible :name, :category_type
  has_many :posts, foreign_key: :category_id
  # belongs_to :blogpost
end
