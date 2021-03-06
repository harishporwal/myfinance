require 'spec_helper'

describe "StaticPages" do
  let(:base_title) {"MyFinance"}
  subject {page}

  shared_examples_for "all_static_pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: page_title) }
  end

  describe "home page" do
    before {visit root_path}
    let(:heading) {"#{base_title}"}
    let(:page_title) {"#{base_title}"}

    it_should_behave_like "all_static_pages"

    describe "for signed in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        sign_in user 
        visit root_path
      end

      it {should_not have_link("Sign up now!")}
    end
  end

  describe "help page" do
    before {visit help_path}
    let(:heading) {"Help"}
    let(:page_title) {"#{base_title} | Help"}

    it_should_behave_like "all_static_pages"
  end

  describe "contact page" do
    before {visit contact_path}
    let(:heading) {"Contact"}
    let(:page_title) {"#{base_title} | Contact"}

    it_should_behave_like "all_static_pages"
  end

  describe "about page" do
    before {visit about_path}
    let(:heading) {"About"}
    let(:page_title) {"#{base_title} | About"}
    
    it_should_behave_like "all_static_pages"
  end

  describe "home page should have proper links for" do
    before {visit root_path}

    describe "Home page" do
      before {click_link "Home"}
      it {should have_selector("title", text: "#{base_title}")}
    end

    describe "home page, when in another page" do
      before do
        visit root_path
        click_link "Help"
        click_link "Home"
      end
      it {should have_selector("title", text: "#{base_title}")}
    end

    describe "help page" do
      before {click_link "Help"}
      it {should have_selector("title", text: "#{base_title} | Help")}
    end

    describe "about page" do
      before {click_link "About"}
      it {should have_selector("title", text: "#{base_title} | About")}
    end
    
    describe "contact page" do
      before {click_link "Contact"}
      it {should have_selector("title", text: "#{base_title} | Contact")}
    end

    describe "user sign up page" do
      before {click_link "Sign up now!"}
      it {should have_selector("title", text: "Sign up")}
    end

    describe "sign in page" do
      before {click_link "Sign in"}
      it {should have_selector("title", text: "Sign In")}
    end
  end

  describe "home page should have links for category stock watchlist " do
    before {visit root_path}

    describe "stock watchlist" do
      it {should have_link("Stock Watchlist")}
    end

    describe "add stock to watchlist" do
      it {should have_link("Add Stock", href: new_stock_watchlist_path)}
    end

    describe "list of stocks" do
      it {should have_link("List of Stocks", href: stock_watchlists_path)}
    end
  end
end
