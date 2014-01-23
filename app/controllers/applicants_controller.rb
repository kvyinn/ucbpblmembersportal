class ApplicantsController < ApplicationController

	def add_image
		image = params[:image]
		applicant = Applicant.find(params[:applicant_id].to_i)
		applicant.image = params[:image]
		applicant.save

		render json: applicant
	end
	def index
		@applicants = Applicant.all
	end
	def new
		if params[:error_message]
			@error_message = params[:error_message]
		end
		if params[:delib_id]
			@deliberation = Deliberation.find(params[:delib_id])
		else
			@deliberation = Deliberation.all.reverse[0]
		end
		@names = Array.new
		@deliberation.applicants.each do |a|
			@names << a.name
		end
		@applicant = Applicant.new
		if params[:applicant]
			@applicant = Applicant.new(params[:applicant])
		end
		@committees = Committee.all
	end
	def destroy
		a = Applicant.find(params[:id])
		if a
			ApplicantRanking.where(applicant: a.id).destroy_all
			a.destroy
		end

		redirect_to(:back)
	end
	# TODO: validation. like a unique email that is actually an email.
	# TODO: display error messages
	def create
		@applicant = Applicant.new(params[:applicant])
		# validate the applicant
		if @applicant.save
			render "success"
		else
			redirect_to new_applicant_path(:error_message => "fix stuff plz", :applicant=>params[:applicant])
		end
	end

	def edit
		@committees = Committee.all
		@applicant = Applicant.find(params[:id])
	end
	def update
		@applicant = Applicant.find(params[:id])
		@applicant.name = params[:applicant][:name]
		@applicant.preference1 = params[:applicant][:preference1]
		@applicant.preference2 = params[:applicant][:preference2]
		@applicant.preference3 = params[:applicant][:preference3]
		@applicant.save
		redirect_to "/applicants"
	end

end
