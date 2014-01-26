class PostsController < ApplicationController

	def index
		if params[:post_id]
			@post = Post.find(params[:post_id])
		end
		@posts = Post.all
		# render "show"
	end

	def show
		begin
			@post = Post.find(params[:id])
		rescue
		end
		@posts = Post.all
		@editing = true
		# render "show"
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
