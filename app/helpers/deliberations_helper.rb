module DeliberationsHelper
	# def help
	# 	return "hello world"
	# end

	# gets deliberation data
	# takes params and returns nodes and links
	# def get_deliberation_data(params)
	# 	exclude = params[:exclude]
	# 	deliberation = Deliberation.find(params[:deliberation_id])
	# 	if exclude
	# 		excluded_committees = exclude.split
	# 	else
	# 		excluded_committees = Array.new
	# 	end
	# 	@applicants = Applicant.where(deliberation_id: deliberation.id)
	# 	@rankings = ApplicantRanking.where(deliberation_id: deliberation.id)
	# 	nodes = Array.new
	# 	for applicant in @applicants
	# 		node = Hash.new
	# 		node["type"] = "applicant"
	# 		node["value"] = applicant
	# 		node["size"] = 5
	# 		node["color"] = "black"
	# 		node["value2"] = applicant.name
	# 		if applicant.image
	# 			node["image"] = applicant.image
	# 		else
	# 			node["image"] = "none"
	# 		end
	# 		nodes << node
	# 	end
	# 	for committee in Committee.all
	# 		if not excluded_committees.include? committee.id.to_s
	# 			node = Hash.new
	# 			node["type"] = "committee"
	# 			node["value"] = committee.name
	# 			node["value2"] = committee.name
	# 			node["abbr"] = committee.abbr
	# 			node["size"] = 10
	# 			node["color"] = "red"
	# 			nodes << node
	# 		end
	# 	end
	# 	links = Array.new
	# 	for ranking in @rankings
	# 		c = Committee.find(ranking.committee)
	# 		committee = c.name
	# 		if not excluded_committees.include? c.id.to_s
	# 			applicant = Applicant.where(deliberation_id: deliberation.id).find(ranking.applicant)
	# 			anode = nodes.find { |l| l["value"] == applicant }
	# 			anode_index = nodes.index(anode)
	# 			cnode = nodes.find { |l| l["value"] == committee }
	# 			cnode_index = nodes.index(cnode)

	# 			link = Hash.new
	# 			link["source"] = cnode_index
	# 			link["source2"] = cnode["value"]
	# 			link["target"] = anode_index
	# 			link["target2"] = anode
	# 			link["rank"] = ranking.value
	# 			link["notes"] = ranking.notes
	# 			link["id"] = ranking.id
	# 			link["message"] = applicant.name+" "+committee
	# 			link["info"] = applicant.id.to_s+" "+c.id.to_s
	# 			if c.id == applicant.preference1
	# 				link["color2"] = "blue"
	# 			elsif c.id == applicant.preference2
	# 				link["color2"] = "grey"
	# 			else
	# 				link["color2"] = "red"
	# 			end
	# 			if ranking.value == 50
	# 				link["color"] = "yellow"
	# 			else
	# 				link["color"] = "blue"
	# 			end
	# 			# if the node is assigned already change its color to green
	# 			if DeliberationAssignment.where(deliberation_id: deliberation.id).where(committee: c.id).where(applicant: applicant.id).length > 0
	# 				link["color"] = "green"
	# 			end
	# 			links << link
	# 		end
	# 	end

	# 	data = Hash.new
	# 	data["nodes"] = nodes
	# 	data["links"] = links
	# 	return data
	# end

	# def generate_default_ranks
	# 	for a in Applicant.all
	# 		committee1 = Committee.find(a.preference1)
	# 		committee2 = Committee.find(a.preference2)
	# 		committee3 = Committee.find(a.preference3)
	# 		committees = [committee1, committee2, committee3]
	# 		for c in committees
	# 			rank = ApplicantRanking.new
	# 			rank.committee = c.id
	# 			rank.applicant = a
	# 			rank.deliberation_id = a.deliberation_id
	# 			rank.value = 50
	# 			rank.save
	# 		end
	# 	end
	# end



	# # deliberation algorithm code below
	# $shaky = Hash.new
	# $bad = Hash.new
	# $test = "teset"
	# def deliberate(delib_id)
	# 	$shaky = Hash.new
	# 	$bad = Hash.new
	# 	$test = ""
	# 	capacity = 7
	# 	applicants = Applicant.where(deliberation_id: delib_id)
	# 	rankings = ApplicantRanking.where(deliberation_id: delib_id)
	# 	rank_lists = Hash.new
	# 	assignments = Hash.new
	# 	unsure = Hash.new
	# 	conflicts = Hash.new
	# 	# initialize ranks list
	# 	for cid in [3,4,5,6,7,9,10,11]
	# 		c = Committee.find(cid)
	# 		rank_lists[c] = Array.new
	# 		unsure[c] = Array.new
	# 		assignments[c] = Array.new
	# 		ranks = ApplicantRanking.where(deliberation_id: delib_id).where(committee: c.id).order(:value)
	# 		for r in ranks
	# 			if Applicant.find(r.applicant)
	# 				rank_lists[c] << Applicant.find(r.applicant)
	# 			end
	# 		end
	# 	end
	# 	assignments = fill_committees(rank_lists, assignments, 7, delib_id)
	# 	count = 1
	# 	conflicts = find_conflicts(assignments)
	# 	while conflicts.length > 0
	# 		assignments = resolve_conflicts(assignments, conflicts, delib_id)
	# 		fill_committees(rank_lists, assignments, 7, delib_id)
	# 		conflicts = find_conflicts(assignments)
	# 		count = count + 1
	# 		if count > 10
	# 			break
	# 		end
	# 	end
	# 	for applicant in $shaky.keys
	# 		for c in $shaky[applicant]
	# 			unsure[c] << applicant
	# 		end
	# 	end
	# 	return [assignments, conflicts, unsure]
	# end

	# # fill each committee to its capacity
	# def fill_committees(rank_lists, assignments, capacity, delib_id)
	# 	for c in assignments.keys
	# 		while (assignments[c].length < capacity)
	# 			if rank_lists[c].length > 0
	# 				person = rank_lists[c][0]
	# 				rank_lists[c].delete_at(0)
	# 				rank = ApplicantRanking.where(applicant: person.id).where(deliberation_id: delib_id).where(committee: c).first
	# 				if rank.value == 50
	# 					$bad[person] = Committee.find(rank.committee)
	# 				end
	# 				assignments[c] << person
	# 			else
	# 				# ran out of people so break out of loop
	# 				break
	# 			end
	# 		end
	# 	end
	# 	return assignments
	# end
	# # return a list of conflicts
	# def find_conflicts(assignments)
	# 	conflicts = Hash.new
	# 	for key in assignments.keys
	# 		for applicant in assignments[key]
	# 			for k in assignments.keys
	# 				if assignments[k].include? applicant and key != k
	# 					if conflicts[applicant]
	# 						if ! conflicts[applicant].include? key
	# 							conflicts[applicant] << key
	# 						end
	# 					else
	# 						conflicts[applicant] = Array.new
	# 						conflicts[applicant] << k
	# 						conflicts[applicant] << key
	# 					end
	# 				end
	# 			end
	# 		end
	# 	end
	# 	return conflicts
	# end
	# def resolve_conflicts(assignments, conflicts, delib_id)
	# 	for applicant in conflicts.keys
	# 		# decide which committee will get the applicant
	# 		# if both committees rank applicant in the same tier use applicant preference
	# 		# if one ranks applicant in a higher tier, give it to that committee
	# 		best_rank = 100
	# 		winning_committees = Array.new
	# 		for c in conflicts[applicant]
	# 			rank = ApplicantRanking.where(deliberation_id: delib_id).where(applicant: applicant.id).where(committee: c.id).first
	# 			if rank.value < best_rank and rank.value-best_rank < -2
	# 				# you're the new winning committee
	# 				winning_committees = Array.new
	# 				winning_committees << c
	# 				best_rank = rank.value
	# 			elsif best_rank < rank.value and best_rank-rank.value< -2
	# 				# youre too much worse than the best committee, do nothing
	# 				puts "i lose"
	# 			else
	# 				# another you're in the same tier as another committee
	# 				winning_committees << c
	# 			end
	# 		end

	# 		if winning_committees.length == 1
	# 			assignments = assign_and_remove(winning_committees[0], applicant, assignments)
	# 		else
	# 			# you need to go by applicant preference
	# 			first_choice = Committee.find(applicant.preference1)
	# 			second_choice = Committee.find(applicant.preference2)
	# 			third_choice = Committee.find(applicant.preference3)
	# 			if winning_committees.include? first_choice
	# 				assignments = assignments = assign_and_remove(first_choice, applicant, assignments)
	# 			elsif winning_committees.include? second_choice
	# 				assignments = assignments = assign_and_remove(second_choice, applicant, assignments)
	# 			else
	# 				# this shouldn't happen but w/e
	# 				assignments = assignments = assign_and_remove(third_choice, applicant, assignments)
	# 			end
	# 			$shaky[applicant] = winning_committees
	# 		end
	# 	end
	# 	# end of loop over applicants in conflicts.keys
	# 	return assignments
	# end
	# def assign_and_remove(committee, applicant, assignments)
	# 	# you need to remove applicant from the other committee assignments
	# 	for c in assignments.keys
	# 		if c != committee
	# 			if assignments[c].include? applicant
	# 				assignments[c].delete(applicant)
	# 			end
	# 		end
	# 	end
	# 	return assignments
	# end


end
