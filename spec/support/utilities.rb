include ApplicationHelper

def test_email
  "keien.is.testerjoe@gmail.com"
end

def test_password
  "dontcare"
end

def test_name
  "Tester Joe"
end

def sign_in
  Capybara.current_driver = :selenium
  visit root_path
  click_link "Sign in with Google"

  if page.has_field? "Email"
    fill_in "Email", with: test_email
    fill_in "Password", with: test_password
    click_button "Sign in"
  end

  click_button "Accept"
  click_button "Accept"

end
