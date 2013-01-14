require 'spec_helper'

describe "AuthenticationPages" do
  let(:base_title) {'MyFinance'}
  subject {page}

  describe "sign-in page" do
    before {visit signin_path}

    it { should have_selector('h1', :text => 'Sign In') }
    it { should have_selector('title', :text => "#{base_title} | Sign In") }
  end

  describe 'signin' do 
    before {visit signin_path}

    describe "with invalid information" do 
      before {click_button 'Sign in'}
      
      it {should have_selector('title', text: 'Sign In')}
      it {should have_selector('div.alert.alert-error', text: 'Invalid')}

      describe "should not display error message, if navigated to another screen" do
        before {click_link "Home"}
        it {should_not have_selector('div.alert.alert-error')}
      end
    end

    describe 'with valid information' do 
      let(:user) {FactoryGirl.create(:user)}
      before {sign_in user}


      it {should have_selector('title', text: "#{base_title}")}
      it {should have_link('Profile', href: user_path(user))}
      it {should have_link('Settings', href: settings_user_path(user))}
      it {should have_link('Sign out', href: signout_path)}
      it {should_not have_link('Sign in', href: signin_path)}

      describe "followed by signout" do 
        before {click_link "Sign out"}

        it {should have_link('Sign in')}
      end
    end
  end

  describe 'authorizations' do 
    describe 'as non signed-in users' do
      let(:user) {FactoryGirl.create(:user)}

      describe 'in userpages controller' do 
        describe 'visiting the profile page' do
          before {visit user_path(user)}

          it {should have_selector('h1', text: 'Sign In')}
        end

        describe 'visiting the settings page' do
          before {visit settings_user_path(user)}

          it {should have_selector('h1', text: 'Sign In')}
        end
      end

      describe 'when attempting to visit a protected page' do 
        before do
          visit user_path(user)
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_button 'Sign in'
        end

        describe 'after signing in' do
          it 'should render the desired protected page' do 
            should have_selector('title', text: "#{base_title} | Profile")
          end
        end
      end
    end

    describe 'as wrong users' do
      let(:user) {FactoryGirl.create(:user)}
      let(:wrong_user) {FactoryGirl.create(:user, email: 'wrong_user@example.com')}
      before {sign_in user}

      describe 'visting users profile page' do
        before {visit user_path(wrong_user)}
        it {should_not have_selector('title', text: "#{base_title} | Profile")}
      end 

      describe 'visiting users setting page' do
        before {visit settings_user_path(wrong_user)}
        it {should_not have_selector('title', text: "#{base_title} | Settings")}
      end
    end

    describe 'in stock_watchlist_controller pages' do 
      describe 'visiting the add stock page' do
        before {visit new_stock_watchlist_path}

        it {should have_selector('h1', text: 'Sign In')}
      end

      describe 'show stock page' do 
        let(:stock) {FactoryGirl.create(:stock_watchlist)}
        before {visit stock_watchlist_path(stock.symbol)}

        it {should have_selector('h1', text: 'Sign In')}
      end

      describe 'submitting to the update action' do 
        let(:stock) {FactoryGirl.create(:stock_watchlist)}
        before {put stock_watchlist_path(stock)}

        specify {response.should redirect_to(signin_path)}
      end

      describe 'visiting the stocks index page' do
        before {visit stock_watchlists_path}

        it {should have_selector('h1', text: 'Sign In')}
      end

      describe 'submitting to the destroy action' do
        before {delete stock_watchlist_path(FactoryGirl.create(:stock_watchlist))}

        specify {response.should redirect_to(signin_path)}
      end
    end
  end
end
