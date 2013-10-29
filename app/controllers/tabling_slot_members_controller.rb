class TablingSlotMembersController < ApplicationController

  before_filter :admin_member

  def create
    if params[:member_id]
      member = Member.find(params[:member_id])
      tabling_slot = TablingSlot.find(params[:tabling_slot_member][:tabling_slot_id])

      member.tabling_slots << tabling_slot
    end

    respond_to do |format|
      format.html { redirect_to tabling_slot }
      format.js
    end
  end

  def update
    tsm = TablingSlotMember.find(params[:id])
    tsm.tabling_slot = TablingSlot.find(params[:tabling_slot_id])

    tsm.save!

    render 'update.js.erb'
  end

  def destroy
    tsm = TablingSlotMember.find(params[:id]).destroy

    respond_to do |format|
      format.html { render 'destroy.js.erb' }
      format.js
    end
  end

  def set_status_for
    tsm = TablingSlotMember.find(params[:id])
    tsm.status_id = params[:status_id]
    tsm.save

    respond_to do |format|
      format.html do
        notice = "You have updated #{tsm.member.name}'s tabling slot status to #{tsm.status.name}."
        redirect_to tsm.tabling_slot, notice: notice
      end
    end
  end
end
