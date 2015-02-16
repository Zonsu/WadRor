require 'rails_helper'

RSpec.describe "styles/edit", type: :view do
  before(:each) do
    @style = assign(:style, Style.create!(
      :style => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit style form" do
    render

    assert_select "form[action=?][method=?]", style_path(@style), "post" do

      assert_select "input#style_style[name=?]", "style[style]"

      assert_select "textarea#style_description[name=?]", "style[description]"
    end
  end
end
