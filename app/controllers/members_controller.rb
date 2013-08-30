class MembersController < ApplicationController

  def index
    if params[:term]
      @members = Member.where('lower(name) LIKE lower(?)', "%#{params[:term]}%")
      @members = @members.map { |member| { label: member.autocomplete_display, value: member.name, id: member.id } }
    else
      @members = Member.all
    end

    respond_to do |format|
      format.json { render :json => @members.to_json }
      end
  end

  def show
    @old_members = OldMember.where(last_name: current_member.name.split[-1])
  end

  def update
    # TODO Move to model
    if params[:old_member_id]
      old_member = OldMember.find(params[:old_member_id])
      if old_member.tier_id == 3

        name = old_member.position.chomp("Committee Member").strip
        committee = Committee.where(
          name: name,
          committee_type_id: CommitteeType.where(name: "committee", tier: 1).first_or_create!.id,
        ).first_or_create!
        current_member.committee_members.where(
          committee_id: committee.id,
          committee_member_type_id: CommitteeMemberType.where(name: "cm", tier: 1).first_or_create!.id,
        ).first_or_create!
      elsif old_member.tier_id == 4

        name = old_member.position.chomp("Chair").strip
        committee = Committee.where(
          name: name,
          committee_type_id: CommitteeType.where(name: "committee", tier: 1).first_or_create!.id,
        ).first_or_create!
        current_member.committee_members.where(
          committee_id: committee.id,
          committee_member_type_id: CommitteeMemberType.where(name: "chair", tier: 2).first_or_create!.id,
        ).first_or_create!
      elsif old_member.tier_id == 5

        name = "Executive"
        committee = Committee.where(
          name: name,
          committee_type_id: CommitteeType.where(name: "admin", tier: 1).first_or_create!.id,
        ).first_or_create!
        current_member.committee_members.where(
          committee_id: committee.id,
          committee_member_type_id: CommitteeMemberType.where(name: old_member.position, tier: 3).first_or_create!.id,
        ).first_or_create!
      elsif old_member.tier_id == 2

        name = "General Members"
        committee = Committee.where(
          name: name,
          committee_type_id: CommitteeType.where(name: "general", tier: 0).first_or_create!.id,
        ).first_or_create!
        current_member.committee_members.where(
          committee_id: committee.id,
          committee_member_type_id: CommitteeMemberType.where(name: "general member", tier: 0).first_or_create!.id,
        ).first_or_create!
      end

    end

    redirect_to current_member
  end

end
