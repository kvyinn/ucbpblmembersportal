class EventMembersController < ApplicationController

  before_filter :officer

  # Mark attendance
  #
  # NOTE: for some reason, on the form, when a selection is submitted as checked after being marked
  # as checked more than once (check, uncheck, check, etc.), then that selection will not be
  # submitted in the request.
  def create
    @members = []
    @members = params[:member_ids].map { |id| Member.find(id) } if params[:member_ids]

    EventMember.where(event_id: params[:event_member][:event_id]).each do |event_member|
      member = event_member.member
      # if current_member.primary_committee == member.primary_committee
      if current_member.current_committee == member.current_committee
        event_member.destroy
      end
    end
    @members.each do |member|
      if current_member.current_committee == member.current_committee
        p params[:event_member]
        member.event_members.create!(params[:event_member])
      end
    end
    redirect_to event_path(params[:id]), notice: "You've updated attendance for this event!"
  end

end
