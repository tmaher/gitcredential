require 'spec_helper'

describe Gitcredential do

  it "can use various backends" do
    f = Gitcredential.new
    f.backend.should eq "default"
    f = Gitcredential.new :backend => "other"
    f.backend.should eq "other"
  end

end
