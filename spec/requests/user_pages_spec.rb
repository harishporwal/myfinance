require 'spec_helper'

describe "UserPages" do
  let(:base_title) {'MyFinance'}
  subject {page}

  describe "signup page" do
    before {visit signup_path}
    let (:submit) {"Create my account"}    

    it {should have_selector('title', text: 'Sign up')}
    it {should have_selector('h1', text: 'Sign up')}

    it "should not create account, with empty data" do
      expect {click_button submit}.not_to change(User, :count)
    end

    it "should create account, with valid data" do
      fill_in "Name", with: "Example User"
      fill_in "Email", with: "example@exampl.com"
      fill_in "Password", with: "password123"
      fill_in "Confirmation", with: "password123"

      expect {click_button submit}.to change(User, :count).by(1)
      should have_link('Sign out')
    end    
  end

  describe "profile page" do 
    let(:user) {FactoryGirl.create(:user)}

    before {visit user_path(user)}

    it {should have_selector('h3', text: user.name)}
    it {should have_selector('title', text: "#{base_title} | Profile")}
  end

  describe "settings page" do 
    let(:user) {FactoryGirl.create(:user)}

    before {visit settings_user_path(user)}

    it {should have_selector('h3', text: user.name)}
    it {should have_selector('title', text: "#{base_title} | Settings")}
  end
end
