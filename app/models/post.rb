class Post < ActiveRecord::Base
  attr_accessible :title, :edit_tier, :view_tier, :member_id, :content, :old_post_id, :category_id, :date
  belongs_to :member
  belongs_to :post_category, foreign_key: :id, primary_key: :category_id
  has_many :blog_events
  has_many :events, :through => :blog_events
  has_many :comments
  has_many :likes
  def event_id
    if self.events.first
      return self.events.first.id
    end
    return ""
  end
  def self.sync_with_old_posts
    OldPost.all.each do |oldpost|
      post = Post.new
      if Post.where(old_post_id: oldpost.id).length > 0
        post = Post.where(old_post_id: oldpost.id).first
      end
      post.old_post_id = oldpost.id
      post.title = oldpost.title
      post.content = oldpost.body
      post.date = oldpost.created_at
      # if Member.where(old_member_id: oldpost.member.id).length > 0
      #   post.member = Member.where(old_member_id: oldpost.member.id)
      # end
      post.save
    end
  end
  def category
    if category_id
      return PostCategory.find(category_id)
    else
      return nil
    end
  end
  def self.permissions
    permissions =
    [
      [ "Only I",               0],
      [ "Executives and I",     5],
      [ "Officers and I",       4],
      [ "Officers, CMs, and I", 3],
      [ "Anyone",               2]
    ]
    Committee.all.each do |committee|
      permissions << ["Only "+committee.name, 100+committee.id]
    end
    return permissions
  end

  def can_view(member)
    return true
  end
  def self.search(term, category)
  	result = Array.new
    term = term.downcase
  	Post.order(:date).all.reverse.each do |post|
  		if (post.title and post.title.downcase.include? term) or (post.content and post.content.downcase.include? term)
  			if category and category != ""
          if post.category and post.category.id.to_s == category
            result << post
          end
        else
          result << post
        end
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
