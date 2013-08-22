class MembersController < ApplicationController

  def show
    @old_member = OldMember.where(last_name: current_member.name.split[-1])
  end

end
