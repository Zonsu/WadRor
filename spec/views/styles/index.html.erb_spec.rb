require 'rails_helper'

RSpec.describe "styles/index", type: :view do
  before(:each) do
    assign(:styles, [
      Style.create!(
        :style => "Style",
        :description => "MyText"
      ),
      Style.create!(
        :style => "Style",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of styles" do
    render
    assert_select "tr>td", :text => "Style".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
