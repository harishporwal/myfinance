require 'spec_helper'

describe Tag do
  let(:stock_watchlist) {FactoryGirl.create(:stock_watchlist)}
  before do
    stock_watchlist.save
    @tag = stock_watchlist.tags.build(name: "Breakout Anticipation")
  end
  
  subject {@tag}

  it { should respond_to(:taggable_type) }
  it { should respond_to(:taggable_id) }
  it { should respond_to(:name) }
  it { should respond_to(:taggable) }

  #it { should be_valid }

  describe 'should not accept blank name' do
    before {@tag.name= ""}
    it { should_not be_valid }
  end

  describe 'should not name greater than 20 characters' do
    before {@tag.name= "a" * 21}
    it { should_not be_valid }
  end

  describe 'should not accept blank type' do
    before {@tag.taggable_type = ""}
    it { should_not be_valid }
  end

  describe 'should not accept blank reference_id' do
    before {@tag.taggable_id = nil}
    it { should_not be_valid }
  end
end
