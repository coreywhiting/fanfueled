require 'rails_helper'

feature "view specfic weeks in baseball matchup index" do

  scenario "with no week parameters" do
    visit baseball_matchup_index_path

    expect(page).to have_content("team averages")
    expect(page).to have_content("z-scores")
  end

  scenario "with 2 to 4 week parameters" do
    visit baseball_matchup_index_path

    fill_in('week_range_first', :with => '2')
    fill_in('week_range_last', :with => '4')
    click_button('week_range_submit')

    expect(page).to have_content("team averages")
    expect(page).to have_content("z-scores")
  end

end