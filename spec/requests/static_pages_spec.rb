require 'spec_helper'

describe "StaticPages" do
  let(:base_title) {"MyFinance"}
  subject {page}

  shared_examples_for "all_static_pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: page_title) }
  end

  describe "Home Page" do
    before {visit root_path}
    let(:heading) {"#{base_title}"}
    let(:page_title) {"#{base_title}"}

    it_should_behave_like "all_static_pages"
  end

  describe "Help Page" do
    before {visit help_path}
    let(:heading) {"Help"}
    let(:page_title) {"#{base_title} | Help"}

    it_should_behave_like "all_static_pages"
  end

  describe "Contact Page" do
    before {visit contact_path}
    let(:heading) {"Contact"}
    let(:page_title) {"#{base_title} | Contact"}

    it_should_behave_like "all_static_pages"
  end

  describe "About Page" do
    before {visit about_path}
    let(:heading) {"About"}
    let(:page_title) {"#{base_title} | About"}
    
    it_should_behave_like "all_static_pages"
  end

  describe "Home page should have proper links for" do
    before {visit root_path}

    describe "Home Page" do
      before {click_link "Home"}
      it {should have_selector("title", text: "#{base_title}")}
    end

    describe "Home page, when in another page" do
      before do
        visit root_path
        click_link "Help"
        click_link "Home"
      end
      it {should have_selector("title", text: "#{base_title}")}
    end

    describe "Help Page" do
      before {click_link "Help"}
      it {should have_selector("title", text: "#{base_title} | Help")}
    end

    describe "About Page" do
      before {click_link "About"}
      it {should have_selector("title", text: "#{base_title} | About")}
    end
    
    describe "Contact Page" do
      before {click_link "Contact"}
      it {should have_selector("title", text: "#{base_title} | Contact")}
    end
  end
end
