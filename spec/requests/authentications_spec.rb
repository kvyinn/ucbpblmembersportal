require 'spec_helper'

describe "Authentications" do
  Capybara.current_driver = :selenium

  subject { page }

  describe "sign in" do
    before { sign_in }
    it { should have_content("Welcome #{test_name}") }
  end
end
