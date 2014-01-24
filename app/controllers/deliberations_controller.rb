class DeliberationsController < ApplicationController
	def index
		@deliberations = Deliberation.all.reverse
	end

	# show the graph view
	def show
		@valid_committees = valid_committees
		@deliberation = Deliberation.find(params[:id])
		@deliberation.clean_assignments
		assigns = DeliberationAssignment.where(deliberation_id: @deliberation.id)
		@assignments = Hash.new
		for c in Committee.all
			@assignments[c] = Array.new
			as = assigns.where(committee:c.id)
			for a in as
				applicant = Applicant.find(a.applicant)
				@assignments[c] << applicant
			end
		end
		render "deliberations"
	end

	def create
		d = Deliberation.new
		if Deliberation.where(name: params[:deliberation][:name]).length == 0
			d.name = params[:deliberation][:name]
			d.save
		end
		redirect_to(:back)
	end

	# makes an assignment for a deliberation. applicant assigned to committee
	def make_assignment
		a_id = params[:a_id]
		c_id = params[:c_id]
		delib_id = params[:delib_id]
		type = params[:assignment_type]
		if type == "unassign"
			DeliberationAssignment.where(deliberation_id: delib_id).where(applicant: a_id).destroy_all
		else
			if ApplicantRanking.where(deliberation_id: delib_id).where(applicant: a_id).where(committee: c_id).length != 0
				DeliberationAssignment.where(deliberation_id: delib_id).where(applicant: a_id).destroy_all
				applicant = Applicant.find(a_id)
				assignment = DeliberationAssignment.new
				assignment.committee = c_id
				assignment.applicant = applicant
				assignment.deliberation_id = delib_id
				assignment.save
			end
		end
		# give back json for assignments
		deliberation = Deliberation.find(delib_id)
		deliberation.clean_assignments
		render json: deliberation.assignments
	end

	# returns nodes and links data ajax call from view
	def deliberations_data
		deliberation = Deliberation.find(params[:deliberation_id])
		data = deliberation.nodes_and_links
		# data = get_deliberation_data(params)
		render json: data
	end

	# runs deliberations algorithm
	def run_deliberations
		# clean_ranks
		@valid_committees = valid_committees
		@delib_id = params[:delib_id]
		# @result = ApplicantRanking.where(deliberation_id: @delib_id)
		@deliberation = Deliberation.find(params[:delib_id])
		# @deliberation.generate_default_rankings
		delib = @deliberation.algorithm_results
		@assignments = delib[0]
		@conflicts = delib[1]
		@shaky = delib[3]
		@bad = delib[4]
		@unassigned = delib[5]
		@remaining = delib[6]
	end

	def get_delib_links
		# delib = deliberate(params[:delib_id])
		delib = Deliberation.find(params[:delib_id]).algorithm_results
		assignments = delib[0]
		conflicts = delib[1]
		unsure = delib[2]
		json_assignments = Hash.new
		for k in assignments.keys
			json_assignments[k.name] = Array.new
			for v in assignments[k]
				json_assignments[k.name] << v.id
			end
		end
		json_unsure = Hash.new
		for k in unsure.keys
			json_unsure[k.name] = Array.new
			for v in unsure[k]
				json_unsure[k.name] << v.id
			end
			# also add all assigned members in committee k
			assigned = DeliberationAssignment.where(deliberation_id: params[:delib_id]).where(committee: k.id)
			for a in assigned
				app = Applicant.find(a.applicant).id
				if not (json_unsure[k.name].include? app and json_assignments.include? app)
					json_unsure[k.name] << app
				end
			end
		end
		render json: [json_assignments, json_unsure]
	end
end
