class ApplicantRankingsController < ApplicationController
	def new_table
		@committee = Committee.find(params[:committee])
		@deliberation = Deliberation.find(params[:delib_id])
		@rankings = @deliberation.applicant_ranks_by_committee(@committee)
		@rankings.sort! {|x,y| x.value <=> y.value}
		render "table_form"
	end

	def new_committee
		@committee = Committee.find(params[:committee])
		@deliberation_id = Deliberation.find(params[:delib_id]).id
		@all = Applicant.where(deliberation_id: @deliberation_id)
		@rankings = ApplicantRanking.where(deliberation_id: @deliberation_id).where(committee: @committee.id)
		@applicants = Array.new
		for applicant in @all
			if applicant.preference1 == @committee.id or applicant.preference2 == @committee.id or applicant.preference3 == @committee.id
				@applicants << applicant
			end
		end
		@pictures = Array.new
		if session[:pictures]
			@pictures = session[:pictures]
		end
		# remove applicants with no ratings yet from the pool
		for a in @applicants
			ranks = ApplicantRanking.where(applicant: a.id).where(committee: @committee.id).where(deliberation_id: @deliberation_id)
			if ranks.length == 0
				@applicants.delete(a)
			end
		end
		@applicants = @applicants.sort_by { |item| ApplicantRanking.where(applicant: item.id).where(committee: @committee.id).where(deliberation_id: @deliberation_id).first.value }
		render "new"
	end

	def new
		# @committee = Committee.find(params[:committee])
		@ranking = ApplicantRanking.new
		# @applicants = Applicant.where(committee:  @committee.id)
		@applicants = Applicant.all
		render "new"
	end

	def create
		@ranking = ApplicantRanking.new(params[:applicant_ranking])
		@ranking.save
		# redirect_to '/deliberations'
		redirect_to(:back)
		# redirect_to applicant_rankings_path
	end

	def update
		@ranking = ApplicantRanking.find(params[:id])
		@ranking.value = params[:applicant_ranking][:value]
		@ranking.notes = params[:applicant_ranking][:notes]
		@ranking.deliberation_id = params[:applicant_ranking][:deliberation_id]
		@ranking.save
		redirect_to(:back)
	end
	def index
		@committees = Committee.all
		@deliberations = Deliberation.all
	end
	def clean_rankings
		bullshit = Array.new
		for c in Committee.all
			for d in Deliberation.all
				for a in Applicant.all
					ranks = ApplicantRanking.where(committee: c.id).where(applicant: a.id).where(deliberation_id: d.id)
					while ranks.length > 0
						d = ranks.pop
						ranks.delete(d)
						d.destroy
					end
				end
			end
		end
		return bullshit
	end

	def submitall
		# clean_rankings
		submit_string = params[:submit_string]
		deliberation_id = params[:deliberation_id]
		cid = params[:committee_id]
		ranks = submit_string.split
		for rank in ranks
			begin
				# puts "modifying a rank"
				# puts cid
				# puts rank
				# puts deliberation_id
				parts = rank.split(",")
				aid = parts[0].to_i
				val = parts[1].to_i
				ranking = ApplicantRanking.where(committee: cid).where(deliberation_id: deliberation_id).where(applicant: aid)
				while ranking.length > 1
					r = ranking.pop
					r.destroy
					ranking = ApplicantRanking.where(committee: cid).where(deliberation_id: deliberation_id).where(applicant: aid)
				end
				ranking = ranking[0]
				# puts ranking
				# puts ranking.applicant
				# puts Applicant.find(ranking.applicant).name
				ranking.value = val
				# puts "val is "+val.to_s
				ranking.save
			rescue
				# puts "Error #{$!}"
				puts "there was an error when trying to save your stuff!"
			end
		end
		render json: "i finished"
	end
end
