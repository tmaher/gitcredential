require 'spec_helper'

describe Gitcredential do

  user_one = SecureRandom.hex 8
  user_two = SecureRandom.hex 8
  pw_one = SecureRandom.hex 8
  pw_two = SecureRandom.hex 8
  
  user_data = { :proto => "https",
    :host => "gitcredential.example.rspec",
    :path => "/",
    :user => user_one }
  
  it "uses the default backend" do
    Gitcredential.new.backend.should eq "default"
  end

  it "only allows known backends" do
    expect { Gitcredential.new(:backend => "necronomicon") }.to raise_exception
    Gitcredential.new(:backend => "osxkeychain").backend.should eq "osxkeychain"
  end

  it "doesn't find nonexistent users" do
    gc = Gitcredential.new
    gc.get(user_data).should be_nil
  end

  it "can save new user accounts" do
    gc = Gitcredential.new
    gc.set(user_data.merge(:password => pw_one)).should be_true
  end

  it "can retrieve user accounts" do
    gc = Gitcredential.new
    gc.get(user_data).should be pw_one
  end

  it "can overwrite passwords" do
    gc = Gitcredential.new
    gc.set(user_data.merge(:password => pw_two))
    gc.get(user_data).should eq pw_two
  end

  it "can delete user accounts" do
    gc = Gitcredential.new
    gc.unset(user_data).should be_true
    gc.get(user_data).should be_nil
  end

  it "can handle multiple accounts concurrently" do
    gc = Gitcredential.new
    gc.get(user_data).should be_nil
    gc.set(user_data.merge(:password => pw_one)).should be_true
    gc.set(user_data.merge(:user => user_two, :password => pw_two)).should be_true
    gc.get(user_data).should eq pw_one
    gc.get(user_data.merge(:user => user_two)).should eq pw_two
  end

  it "does cleanup" do
    gc.unset(user_data)
    gc.unset(user_data.merge(:user => user_two))
  end
  
  1
  
end
