require 'spec_helper'

describe User do
  before(:all) do
    [:admin_role, :user_role].each do |role|
      Factory.create(role)
    end
  end

  describe "when new" do
    specify { should_not be_valid }
    its(:to_s) { should == "" }
    its(:current_company) { should be_nil }
  end

  describe "as admin" do
    subject { Factory.create :admin_user }

    describe "should be valid" do
      specify { should be_valid }
      specify { should be_role(:admin) }
      its(:role_texts) { should == ["admin"] }
    end

    it "should add it to the accountant role" do
      admin = Factory.create(:admin_user)
      admin.role_texts = ['accountant', 'admin']
      admin.save!
      admin.should be_valid
      admin.should be_role(:accountant)
      admin.should be_role(:admin)
    end
  end

  describe "as accountant" do
    subject { Factory.create(:accountant_user) }

    describe "should be valid" do
      specify { should be_valid }
      specify { should be_role(:accountant) }
      specify { should_not be_role(:admin) }
    end

    it "should add it to the admin role" do
      accountant = Factory.create(:accountant_user)
      accountant.role_texts = ['admin', 'accountant']
      accountant.save!
      accountant.should be_valid
      accountant.should be_role(:accountant)
      accountant.should be_role(:admin)
    end
  end
end
