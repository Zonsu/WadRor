require 'rails_helper'


describe Beer do

  it "creates a new beer" do
 beer = Beer.create name:"Limu", style:"Lager"
  expect(beer).to be_valid

  end
  it "is not created without a name" do
    beer = Beer.create style:"Lager"
    expect(beer).not_to be_valid

  end

  it "is not created without a style" do
    beer = Beer.create name:"Limu"
    expect(beer).not_to be_valid

  end

end
