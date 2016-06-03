class BaseballMatchupController < ApplicationController
  def index
    @first_week = week_range_params[:first]
    @last_week = week_range_params[:last]

    stats = [ :runs,
              :hr,
              :rbi,
              :sb,
              :obp,
              :slg,
              :ip,
              :qs,
              :sv,
              :era,
              :whip,
              :k9 ]

    #calc
    @members = Member.all.order(espn_id: :desc)
    @team_averages = Array.new
    @stat_means = {}
    @stat_stddev = {}

    @members.each do |m|
      @team_averages[m.espn_id] = {
          :runs => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:runs),
          :hr => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:hr),
          :rbi => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:rbi),
          :sb => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:sb),
          :obp => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:obp),
          :slg => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:slg),
          :ip => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:ip),
          :qs => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:qs),
          :sv => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:sv),
          :era => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:era),
          :whip => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:whip),
          :k9 => BaseballMatchup.where(espn_id: m.espn_id, week: week_range_params[:first].to_i..week_range_params[:last].to_i).average(:k9)
      }
    end
  end

  private
    def week_range_params
      params.require(:week_range).permit(:first, :last)
    end
end
