require 'rails_helper'

feature "view specfic weeks in baseball matchup index" do

  scenario "with no week parameters" do
    visit baseball_matchup_index_path

    expect(page).to have_content("team averages")
    expect(page).to have_content("z scores")
  end

end