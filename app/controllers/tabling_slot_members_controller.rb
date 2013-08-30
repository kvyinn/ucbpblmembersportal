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
end
