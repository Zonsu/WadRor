require 'rails_helper'
include OwnTestHelper

RSpec.describe User, :type => :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too sort password" do
    user = User.create username:"Pekka", password:"k0e", password_confirmation:"k0e"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password contaning only letters" do
    user = User.create username:"Pekka", password:"letters", password_confirmation:"letters"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating(10, user)
      best = create_beer_with_rating(25, user)
      create_beer_with_rating(7, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if one rating" do
      lager = Style.new style:"Lager"
      create_beers_with_ratings_and_style(10, lager, user)

      expect(user.favorite_style.to_s).to eq("Lager")
    end

    it "is the style with highest average rating if several rated" do

      lager = Style.new style:"Lager"
      ipa = Style.new style:"IPA"
      porter = Style.new style:"Porter"

      create_beers_with_ratings_and_style(10, 20, 15, lager, user)
      create_beers_with_ratings_and_style(35, ipa, user)
      create_beers_with_ratings_and_style(25, 20, 15, porter, user)

      expect(user.favorite_style.to_s).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of only rated if one rating" do
      brewery = FactoryGirl.create(:brewery, name:"Koff")
      create_beers_with_ratings_and_brewery(10, brewery, user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with highest average rating if several rated" do
      plevna = FactoryGirl.create(:brewery, name:"Plevna")
      create_beers_with_ratings_and_brewery(10, 20, 15, FactoryGirl.create(:brewery), user)
      create_beers_with_ratings_and_brewery(35, plevna , user)
      create_beers_with_ratings_and_brewery(25, 20, 15, FactoryGirl.create(:brewery), user)

      expect(user.favorite_brewery).to eq(plevna)
      end
  end
end
