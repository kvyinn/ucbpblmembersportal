class ReimbursementsController < ApplicationController

  def index
    @reimbursements = Reimbursement.all
  end

  def show
    @reimbursement = Reimbursement.find(params[:id])
  end

  def new
    @member = Member.find(params[:member_id]) if params[:member_id]
    @committee = Committee.find(params[:committee_id]) if params[:committee_id]
    @reimbursement = Reimbursement.new(member_id: params[:member_id])
  end

  def create
    Member.find(params[:reimbursement][:member_id]).reimbursements << Reimbursement.create(params[:reimbursement])
    redirect_to reimbursements_path
  end

  def destroy
    reimbursement = Reimbursement.find(params[:id]).destroy
    redirect_to reimbursements_path
  end

end
