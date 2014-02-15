class Post < ActiveRecord::Base
  attr_accessible :title, :edit_tier, :view_tier, :member_id, :content, :old_post_id, :category_id, :date, :view_permissions
  serialize :view_permissions
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
    # chair 2 exec 3 cm 1 anyone 0
    permissions =
    [
      [ "Only I",               10],
      [ "Executives and I",     3],
      [ "Officers and I",       2],
      [ "Officers, CMs, and I", 1],
      [ "Anyone",               0]
    ]
    Committee.all.each do |committee|
      permissions << ["Only "+committee.name, 100+committee.id]
    end
    return permissions
  end

  def can_view(member)

    permissions = self.view_permissions
    if permissions == nil or permissions == ""
      return true
    end
    if permissions.split.include? member.id.to_s
      return true
    end
    return false

    # if not self.view_tier
    #   return true
    # end
    # if self.view_tier < 99
    #   return self.view_tier <= member.tier
    # else
    #   if not member.current_committee
    #     return false
    #   end
    #   return member.current_committee.id == self.view_tier-100
    # end
    # return false
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
