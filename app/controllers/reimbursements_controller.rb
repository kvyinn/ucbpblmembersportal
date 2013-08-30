class ReimbursementsController < ApplicationController

  before_filter :admin_member, only: [ :new, :create, :destroy ]

  def index
    @reimbursements = Reimbursement.all
  end

  def show
    @reimbursement = Reimbursement.find(params[:id])
  end

  def new
    @reimbursement = Reimbursement.new
  end

  def create
    params[:reimbursement].delete :member
    @reimbursement = Reimbursement.new(params[:reimbursement])

    if !params[:member_id].blank? and @reimbursement.save
      Member.find(params[:member_id]).reimbursements << @reimbursement

      flash[:success] = "You've added a reimbursement!"
      redirect_to reimbursements_path
    else
      render 'new'
    end
  end

  def destroy
    reimbursement = Reimbursement.find(params[:id]).destroy

    flash[:success] = "You've cleared a reimbursement!"
    redirect_to reimbursements_path
  end

end
