require "rails_helper"

describe BaseballMatchup do
  before(:all) do
    @matchup = BaseballMatchup.new(espn_id: nil, week: 1)
  end

  it 'should have a week integer' do
    expect(@matchup.week).to eq(1)
  end

  # it 'is invalid without an espn_id' do
  #   bm = BaseballMatchup.new(espn_id: nil)
  #   bm.valid?
  #   expect(bm.errors[:espn_id]).to include("can't be blank")
  # end
  # it 'is invalid without a week' do
  #   bm = BaseballMatchup.new(week: nil)
  #   bm.valid?
  #   expect(bm.errors[:week]).to include("can't be blank")
  # end

end