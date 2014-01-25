task :fall_delib => :environment do
	name = "Fall 2013 Deliberations"
	Deliberation.where(name: name).destroy_all
	d = Deliberation.new
	d.name = name
	d.save
	names = [
		"Chengjun Wu",
		"Duyen Lulu Tran",
		"Fareeda Inamdar",
		"Hei Shun (Charlene) Fung",
		"Judy Yongxin Ji",
		"Michael Tom",
		"Ming Xue",
		"Ning Zhuang",
		"Alice Sun",
		"Amy Nguyen",
		"Betina Yin",
		"Brandon Ye",
		"Daniel Du",
		"Epiphany Ryu",
		"Jesar Shah",
		"Mimi Tam",
		"Siddharth Moghe",
		"Sonny Chen",
		"Yun Park",
		"Bonnie Xiao",
		"Albert Lin",
		"Austin Hsu Chen",
		"Brenda Rocha",
		"Christina Ong",
		"Chynna Wong",
		"Emily Larson",
		"Evelyn Wang",
		"Evelyn Zhai",
		"Haruko Hayabe",
		"Ka Yan Samatha Tong (Sammy)",
		"Katie Chou",
		"Kris Gao",
		"Krishna Mocherla",
		"Marvin Yang",
		"Michael Randall",
		"Sophie Wan",
		"Yadanar Oo",
		"Yen Chen (Andy) Lin",
		"Alex Wang",
		"Alexander Koch",
		"Christine (Chun-Ju) Shih",
		"David Liu",
		"Eric Park",
		"Hoi Ning Liu",
		"JaeHoon Kim",
		"Janet Dong",
		"Kevin Zhang",
		"London Lee",
		"Margaret Chu",
		"Minolee Vora",
		"Na Young (Nadia) Kim",
		"Nicole Martinez",
		"Patrick Chang",
		"Rich Lin",
		"Steve Hwang",
		"Tianyao (Lucia) Wang",
		"William Chen",
		"Winky Wong",
		"Yeu-Jye Pei",
		"Yifei Ding",
		"Yuan Shen (Charles) Zhu",
		"Yuchen Cai",
		"Aida",
		"Albert Huang",
		"Ashley Lee",
		"Beibei Liu",
		"Chase Yuze Guo",
		"Clarinda Irene Chandra",
		"Elaine Chae",
		"Evelyn Yeung",
		"Gokulkrishna Asokan",
		"Huipu Wang",
		"Jamie Ho",
		"Jessica Fu",
		"Jieqiong Wang",
		"Jingjin (Jane) Li",
		"Jocelyn Shieh",
		"Joey Choi",
		"Judy Jiang",
		"Kevin Qi",
		"Liliya Kriulina",
		"Matt Briggs",
		"Mohan Ganesan",
		"Patrick Burden",
		"Patrick Tze",
		"Raymond Dang",
		"Richard Liaw",
		"Rocky Yip",
		"Tammy Chen",
		"Tammy Ho",
		"Timothy Quach",
		"Vanessa Cheuk",
		"Xuan Ji",
		"Yunpeng Yu"
	]
	first_choices = [
		"Consulting",
		"Marketing",
		"Community Service",
		"Consulting",
		"Consulting",
		"Finance",
		"Professional Development",
		"Professional Development",
		"Publications",
		"Consulting",
		"Community Service",
		"Publications",
		"Community Service",
		"Community Service",
		"Social",
		"Historian",
		"Consulting",
		"Publications",
		"Social",
		"Historian",
		"Finance",
		"Finance",
		"Marketing",
		"Historian",
		"Social",
		"Consulting",
		"Community Service",
		"Finance",
		"Finance",
		"Social",
		"Community Service",
		"Marketing",
		"Consulting",
		"Finance",
		"Marketing",
		"Consulting",
		"Professional Development",
		"Community Service",
		"Consulting",
		"Professional Development",
		"Consulting",
		"Publications",
		"Consulting",
		"Consulting",
		"Marketing",
		"Consulting",
		"Finance",
		"Community Service",
		"Professional Development",
		"Social",
		"Social",
		"Marketing",
		"Social",
		"Marketing",
		"Marketing",
		"Professional Development",
		"Marketing",
		"Finance",
		"Publications",
		"Marketing",
		"Professional Development",
		"Community Service",
		"Marketing",
		"Finance",
		"Consulting",
		"Social",
		"Marketing",
		"Finance",
		"Finance",
		"Consulting",
		"Finance",
		"Marketing",
		"Finance",
		"Social",
		"Finance",
		"Consulting",
		"Finance",
		"Professional Development",
		"Finance",
		"Marketing",
		"Professional Development",
		"Finance",
		"Finance",
		"Marketing",
		"Marketing",
		"Marketing",
		"Consulting",
		"Consulting",
		"Marketing",
		"Consulting",
		"Professional Development",
		"Consulting",
		"Social",
		"Marketing"
	]
	second_choices = [
		"Professional Development",
		"Finance",
		"Professional Development",
		"Marketing",
		"Social",
		"Marketing",
		"Social",
		"Social",
		"",
		"",
		"Community Service",
		"",
		"",
		"Consulting",
		"",
		"",
		"",
		"",
		"",
		"",
		"Community Service",
		"Consulting",
		"Community Service",
		"Publications",
		"Marketing",
		"Finance",
		"Professional Development",
		"Historian",
		"Publications",
		"Community Service",
		"Marketing",
		"Social",
		"Finance",
		"Community Service",
		"Finance",
		"Publications",
		"Consulting",
		"Finance",
		"Historian",
		"Community Service",
		"Marketing",
		"Historian",
		"Finance",
		"Professional Development",
		"Professional Development",
		"Marketing",
		"Community Service",
		"Professional Development",
		"Social",
		"",
		"Publications",
		"Professional Development",
		"Community Service",
		"Community Service",
		"Community Service",
		"Consulting",
		"Consulting",
		"Social",
		"Finance",
		"Social",
		"Social",
		"Finance",
		"",
		"Consulting",
		"",
		"Finance",
		"Finance",
		"",
		"Consulting",
		"Finance",
		"Marketing",
		"Marketing",
		"Publications",
		"Marketing",
		"Consulting",
		"",
		"Consulting",
		"",
		"Historian",
		"Finance",
		"",
		"Consulting",
		"Marketing",
		"Finance",
		"",
		"Finance",
		"Finance",
		"Finance",
		"",
		"",
		"Consulting",
		"Marketing",
		"",
		"Professional Development"
	]
	third_choices = [
		"Finance",
		"Professional Development",
		"",
		"Finance",
		"",
		"Community Service",
		"Finance",
		"",
		"",
		"",
		"",
		"",
		"",
		"Finance",
		"",
		"",
		"",
		"",
		"",
		"",
		"Marketing",
		"Marketing",
		"Social",
		"",
		"",
		"Marketing",
		"Marketing",
		"",
		"Social",
		"Consulting",
		"Social",
		"Consulting",
		"Professional Development",
		"Marketing",
		"Consulting",
		"Marketing",
		"",
		"",
		"Professional Development",
		"",
		"Finance",
		"",
		"",
		"Marketing",
		"Historian",
		"Publications",
		"",
		"",
		"",
		"",
		"Professional Development",
		"Community Service",
		"Historian",
		"Publications",
		"Professional Development",
		"Finance",
		"",
		"Historian",
		"Marketing",
		"Community Service",
		"Finance",
		"Professional Development",
		"",
		"Social",
		"",
		"Professional Development",
		"",
		"",
		"",
		"",
		"",
		"Marketing",
		"Marketing",
		"",
		"Social",
		"",
		"Professional Development",
		"",
		"Publications",
		"Consulting",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"Professional Development",
		"",
		"",
		"Finance",
		"",
		"",
		""	]
	names.each_with_index do |item, index|
		a = Applicant.new
		a.deliberation_id = d.id
		a.name = names[index]
		a.preference1 = Committee.where(name: first_choices[index]).first.id
		puts "first worked"
		s = second_choices[index]
		if s == ""
			s = "Executive"
		end
		a.preference2 = Committee.where(name: s).first.id
		puts "second worked"
		t = third_choices[index]
		if t == ""
			t = "Executive"
		end
		a.preference3 = Committee.where(name: t).first.id
		puts "third worked"
		a.save
		puts "saved"
		puts a.name
	end
	d.generate_default_rankings
	# aps = Applicant.where(deliberation_id: d.id)
	# for ap in aps
	# 	ranking = ApplicantRanking.new
	# 	ranking.value = 50
	# 	ranking.applicant = ap
	# 	ranking.deliberation_id = d.id
	# 	ranking.committee = ap.preference3
	# 	ranking.save
	# end
	# for ap in aps
	# 	ranking = ApplicantRanking.new
	# 	ranking.value = 50
	# 	ranking.applicant = ap
	# 	ranking.deliberation_id = d.id
	# 	ranking.committee = ap.preference1
	# 	ranking.save
	# end
	# for ap in aps
	# 	ranking = ApplicantRanking.new
	# 	ranking.value = 50
	# 	ranking.applicant = ap
	# 	ranking.deliberation_id = d.id
	# 	ranking.committee = ap.preference2
	# 	ranking.save
	# end
end

# task :fall_delib2 => :environment do
# 	deliberation = Deliberation.where(name: "fall 2013 deliberationsz").first
# 	aps = Applicant.where(deliberation_id: deliberation.id)
# 	puts "my id was"
# 	puts deliberation.id
# 	for ap in aps
# 		ranking = ApplicantRanking.new
# 		ranking.value = 50
# 		ranking.applicant = ap
# 		ranking.committee = ap.preference3
# 		ranking.deliberation_id = deliberation.id
# 		ranking.save
# 	end
# 	for ap in aps
# 		ranking = ApplicantRanking.new
# 		ranking.value = 50
# 		ranking.applicant = ap
# 		ranking.committee = ap.preference1
# 		ranking.deliberation_id = deliberation.id
# 		ranking.save
# 	end
# 	for ap in aps
# 		ranking = ApplicantRanking.new
# 		ranking.value = 50
# 		ranking.applicant = ap
# 		ranking.committee = ap.preference2
# 		ranking.deliberation_id = deliberation.id
# 		ranking.save
# 	end
# 	puts "good"
# end