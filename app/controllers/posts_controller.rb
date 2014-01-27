class PostsController < ApplicationController
	require 'will_paginate/array'
	def index
		# @posts = Post.all.order(:date).reverse
		@posts = Post.order(:date).reverse.paginate(:page => params[:page], :per_page => 30)
		if params[:term]
			term = params[:term]
			@posts = Post.search(term).paginate(:page => params[:page], :per_page => 30)
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
	end

	def new
		@post = Post.new
		render :layout => nil
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
