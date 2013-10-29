# == Schema Information
#
# Table name: members
#
#  id             :integer          not null, primary key
#  provider       :string(255)
#  uid            :string(255)
#  name           :string(255)
#  remember_token :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  old_member_id  :integer
#

require 'spec_helper'

describe Member do

  let(:member) { FactoryGirl.create(:member) }

  subject { member }

  it { should respond_to(:name) }
  it { should respond_to(:remember_token) }

  describe "validations" do

    describe "when provider is blank" do
      before { member.provider = "" }
      it { should_not be_valid }
    end

    describe "when uid is blank" do
      before { member.uid = "" }
      it { should_not be_valid }
    end

    describe "when name is blank" do
      before { member.name = "" }
      it { should_not be_valid }
    end

  end

end
