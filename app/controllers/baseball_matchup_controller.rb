class BaseballMatchupController < ApplicationController
  def index
    @first_week = week_range_params[:first] || 1
    #TODO find default last week
    @last_week = week_range_params[:last] || 99

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
          :runs => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:runs),
          :hr => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:hr),
          :rbi => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:rbi),
          :sb => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:sb),
          :obp => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:obp),
          :slg => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:slg),
          :ip => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:ip),
          :qs => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:qs),
          :sv => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:sv),
          :era => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:era),
          :whip => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:whip),
          :k9 => BaseballMatchup.where(espn_id: m.espn_id, week: @first_week..@last_week).average(:k9)
      }
    end
  end

  private
    def week_range_params
      params.fetch(:week_range, {}).permit(:first, :last)
    end
end
