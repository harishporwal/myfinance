require 'spec_helper'

describe User do
 before {@user = User.new(name: "Example User", email: "example@example.com", 
                          password: "password", password_confirmation: "password")}
  subject {@user}

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe 'should not accept blank names' do
    before {@user.name = ""}
    it { should_not be_valid }
  end

  describe 'should not accept blank email ' do
    before {@user.email= ""}
    it { should_not be_valid }
  end

  describe 'should not accept names with > 50 characters' do
    before {@user.name = "a" * 51}
    it { should_not be_valid }
  end

  describe "check for email format" do
    it "email format should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        should_not be_valid
      end      
    end

    it "email format should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        should be_valid
      end      
    end

    it "unique email addresses" do 
      user_with_same_address = @user.dup
      user_with_same_address.email = @user.email.upcase
      user_with_same_address.save

      should_not be_valid
    end

    it "should always save email address in lower case" do 
      mixed_case_email = "HarIsh.PorRwal@gmail.COM"
      @user.email = mixed_case_email
      @user.save
      @user.reload.email == mixed_case_email.downcase
    end
  end
  
  describe "password validations" do 
    it "should return false when password is not present" do 
      @user.password = @user.password_confirmation = ""
      should_not be_valid
    end

    it "should return false when password does not match confirmation" do 
      @user.password_confirmation = "mismatch"
      should_not be_valid
    end

    it "should return false when password confirmation is nil" do
      @user.password_confirmation = nil 
      should_not be_valid
    end

    it "should return false, if the password length is less than 8" do 
      @user.password = @user.password_confirmation = "a" * 6
      should_not be_valid
    end
  end
  
  describe "authenticate method tests" do 
    before {@user.save}
    let (:found_user) {User.find_by_email(@user.email) }

    it "should return true for correct passwords" do 
      should == found_user.authenticate(@user.password)
    end

    it "should return false for incorrect passwords" do
      user_for_invalid_password = found_user.authenticate("invalid password")
      should_not == user_for_invalid_password
      user_for_invalid_password.should be_false
    end
  end
end
