class Post < ActiveRecord::Base
  attr_accessible :title, :edit_tier, :view_tier, :member_id, :content


  def self.search(term)
  	result = Array.new
  	Post.all.each do |post|
  		if (post.title and post.title.include? term) or (post.content and post.content.include? term)
  			result << post
  		end
  	end
  	return result
  end

  def self.search_by_category(category)

  end

  def created_by
  	begin
  		member = Member.find(self.member_id)
  		return member
  	rescue
  		return nil
  	end
  end
end
