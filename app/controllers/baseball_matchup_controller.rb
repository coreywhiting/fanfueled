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

    #CALCULATIONS
    @members = Member.all.order(espn_id: :desc)

    #TEAM AVERAGES
    #weekly averages for a team over start/end week parameters
    @team_averages = Array.new
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

    #STAT MEAN/STDEV
    #for all members, find mean and st dev of a stat over a week. will be used for z-scores and matchups
    @stat_means = {}
    @stat_stddev = {}

    stats.each do |s|
      @stat_means[s] = BaseballMatchup.where(week: @first_week..@last_week).average(s)

      squared_numbers_minus_means = Array.new
      numbers = Array.new

      #get all average of stat into an array
      @team_averages.each do |t|
        if t != nil
          numbers << t[s]
        end
      end

      numbers.each do |n|
        squared_numbers_minus_means << (n.to_f - @stat_means[s].to_f) * (n.to_f - @stat_means[s].to_f)
      end
      mean_squared_diffs = squared_numbers_minus_means.inject{ |sum, el| sum + el }.to_f / squared_numbers_minus_means.size

      @stat_stddev[s] = Math.sqrt(mean_squared_diffs)
    end

    #ZSCORES
    #how far away from the mean is each member?
    #winners and losers represent a team > or < .5 standard deviations from the mean
    @zscores = Hash.new{|h, k| h[k] = []}

    @members.each do |m|
      @zscores[m.espn_id][12] = 0 #winners
      @zscores[m.espn_id][13] = 0 #losers

      stats.each_with_index do |stat,i|
        @zscores[m.espn_id][i] = (@team_averages[m.espn_id][stat].to_f - @stat_means[stat].to_f) / @stat_stddev[stat].to_f

        if i == 9 || i == 10
          @zscores[m.espn_id][i] = @zscores[m.espn_id][i] * -1
        end

        if (@zscores[m.espn_id][i] > 0.5)
          @zscores[m.espn_id][12] = @zscores[m.espn_id][12] + 1 #winners
        elsif (@zscores[m.espn_id][i] < -0.5)
          @zscores[m.espn_id][13] = @zscores[m.espn_id][13] + 1 #losers
        end

      end
    end

  end

  private
    def week_range_params
      params.fetch(:week_range, {}).permit(:first, :last)
    end
end
