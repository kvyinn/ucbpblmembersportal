class EventMembersController < ApplicationController

  before_filter :officer

  def create
    @members = []
    @members = params[:member_ids].map { |id| Member.find(id) } if params[:member_ids]

    EventMember.where(event_id: params[:event_member][:event_id]).each do |event_member|
      member = event_member.member
      if current_member.primary_committee == member.primary_committee
        event_member.destroy
      end
    end
    @members.each do |member|
      if current_member.primary_committee == member.primary_committee
        member.event_members.create!(params[:event_member])
      end
    end
    redirect_to event_path(params[:id]), notice: "You've updated attendance for this event!"
  end

end
