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
		@applicant.save
		# also create a default ranking for the applicant for each of his preferences
		committee1 = Committee.find(@applicant.preference1)
		committee2 = Committee.find(@applicant.preference2)
		committee3 = Committee.find(@applicant.preference3)
		committees = [committee1, committee2, committee3]
		for c in committees
			rank = ApplicantRanking.new
			rank.committee = c.id
			rank.applicant = @applicant
			rank.deliberation_id = @applicant.deliberation_id
			rank.value = 50
			rank.save
		end
		# clean rankings
		redirect_to(:back)
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
