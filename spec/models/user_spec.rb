require 'spec_helper'

describe User do
  
  before { @user = User.new(name: 'Example User', email: 'user@example.com',
                            password: 'foobar', password_confirmation: 'foobar') }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password is nil" do
    before { @user.password = @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'a'*51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should not be valid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_addr|
        @user.email = invalid_addr
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com user@foo.org example.user@foo.jp foo+bar@baz.cn MIXEDcase@here.com]
      addresses.each do |addr|
        @user.email = addr
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

end
