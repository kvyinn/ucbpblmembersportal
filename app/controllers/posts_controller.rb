class PostsController < ApplicationController
	# require 'will_paginate/array'
	def index
		# @posts = Post.all.order(:date).reverse
		@posts = Kaminari.paginate_array(Post.order(:date).reverse).page(params[:page]).per(35)
		# @posts = .page(params[:page]).per(30)
		# paginate(:page => params[:page], :per_page => 30)

		if params[:term]
			term = params[:term]
			cat = params[:category]
			@posts = Kaminari.paginate_array(Post.search(term, cat)).page(params[:page]).per(35)
		end
		if params[:post_id]
			@post = Post.find(params[:post_id])
		end

		# calendar stuff
		@calendar_posts = Array.new
		for p in Post.all
			if p.date
				@calendar_posts << p
			end
		end
		@date = params[:month] ? Date.parse(params[:month]) : Date.today
		# end of calendar stuff

		# render "c_test"
		# render "show"
	end
	def calendar
		@calendar_posts = Array.new
		for p in Post.all
			if p.date
				@calendar_posts << p
			end
		end
		@date = params[:month] ? Date.parse(params[:month]) : Date.today
		render "_calendar", :layout => false
	end
	def show
		@post = Post.find(params[:id])
		@comments = @post.comments
	end

	def edit
		@post = Post.find(params[:id])
		render "new"
	end

	def new
		@post = Post.new
		# render :layout => nil
	end

	def update
		@post = save_post(params[:post], params[:id])
		puts params
		if params[:event][:event_id] and params[:event][:event_id] != ""
			@post.events = Array.new
			event = Event.find(params[:event][:event_id])
			@post.events << event
		end
		# @post = Post.find(params[:post][:id])
		redirect_to @post
	end
	def create
		@post = save_post(params[:post], params[:id])
		if params[:event][:event_id] and params[:event][:event_id] != ""
			@post.events = Array.new
			event = Event.find(params[:event][:event_id])
			@post.events << event
		end
		# @post = Post.find(params[:post][:id])
		redirect_to @post
	end
	def email
		@all_members = Member.all

		@member_hash = Hash.new
		@member_names = Array.new
		@current_cm_names =  Array.new
		@inv_member_hash = Hash.new
		Member.all.each do |m|
			@member_hash[m.name] = m.id
			@inv_member_hash[m.id] = m.name
			@member_names << m.name
			if m.current_committee and not m.current_committee.name.include? "General"
				@current_cm_names << m.name
			end
		end

		# @member_hash = @member_hash.to_json
		if params[:post_id]
			@post = Post.find(params[:post_id])
		end
		# send an email to me
		# UserMailer.blog_email(current_member, @post).deliver
	end
	def email_success
	end
	def send_emails
		member_ids = params[:member_ids]
		@post = Post.find(params[:post_id])
		UserMailer.blog_email(current_member, @post).deliver
		render json: "hello there yung fellow"
	end
	def save_post(params, id)
		puts "hello you are creating or editing a blogpost"
		@post = Post.new(params)
		puts params
		if id and Post.find(id)
			@post = Post.find(id)
			@post.update_attributes(params)
		end
		@post.member_id = current_member.id
		if not @post.date
			@post.date = DateTime.now
		end
		@post.save
		return @post
	end

	def add_comment
		p 'adding a comment'
		c = Comment.new
		c.member_id = current_member.id
		c.post_id = params[:post_id]
		c.content = params[:content]
		c.save
		post = Post.find(params[:post_id])
		@comments = post.comments
		render "comments"

	end
	def delete_comment
		c = Comment.find(params[:comment_id])
		c.destroy
		redirect_to(:back)
	end
	def search_posts
		term = params[:term]
		@posts = Post.search(term)
		render :partial => "posts", :locals => { :posts => @posts }
	end

	def mercury_update
		for key in params[:content].keys
			if key == "new-post"
				post = Post.new
			else
				post = Post.find(key)
			end
			post.member_id = current_member.id #TODO should have created by and updated by
			post.content = params[:content][key]["value"]
			post.save
			# puts key
			# puts params[:content][key]["value"]
		end
		render json: "you have saved your stuff"
	end
end
