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

    if params[:old_member_id]
      current_member.old_member = OldMember.find(params[:old_member_id])
      current_member.update_from_old_member
    end

    redirect_to root_path, notice: "You've updated your information!"
  end

end
