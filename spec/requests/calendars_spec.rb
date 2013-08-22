require 'spec_helper'

describe "Calendars" do

  before do
    sign_in
    visit calendars_path
  end

  subject { page }

  it { should have_content("calendar") }
end
