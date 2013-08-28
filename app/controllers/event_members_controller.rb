class EventMembersController < ApplicationController

  def create
    @members = []
    @members = params[:member_ids].map { |id| Member.find(id) } if params[:member_ids]

    EventMember.where(event_id: params[:event_member][:event_id]).destroy_all
    @members.each do |member|
      member.event_members.create!(params[:event_member])
    end
    redirect_to event_path(params[:id])
  end

end
