class BaseballMatchupController < ApplicationController
  def scrape
    # #update team names
    # @name_scrape = BaseballScraper.new('http://games.espn.go.com/flb/standings?leagueId=2735&seasonId=2016')
    #
    # data_teams = @name_scrape.data.css('#content > div > div.gamesmain.container > div > div > div > table:nth-child(2) > tr > td > table > tr > td > a')
    #
    # Member.delete_all
    # Member.reset_pk_sequence
    # data_teams.each do |t|
    #   Member.create(name: t.text, ESPN_id: t.attr("href").partition('teamId=').last.partition('&').first)
    # end

    teams = Member.all

    MatchupBaseball.delete_all
    MatchupBaseball.reset_pk_sequence

    # weeks = Array(1..19)
    # weeks = Array(1..4)
    weeks = Array(params[:scrape][:start_week]..params[:scrape][:end_week])

    weeks.each do |w|
      @scrape = BaseballScraper.new('http://games.espn.go.com/flb/scoreboard?leagueId=2735&seasonId=2016&matchupPeriodId='+w.to_s)

      #matchup for 12 teams
      teams.each_with_index do |t, i|
        mb = MatchupBaseball.new
        d = i + 1

        mb.week = w
        mb.team = Member.find_by_name(@scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[@class='teamName']/a").text.to_s).ESPN_id
        mb.runs = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_20')]").children.text
        #mb.hr = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_5') and string-length('_5') + 1) = '_5']").children.text
        mb.hr = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_20')]/following::td")[0].children.text
        mb.rbi = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_21')]").children.text
        mb.sb = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_23')]").children.text
        mb.obp = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_17')]").children.text
        mb.slg = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_17')]/following::td")[0].children.text
        mb.ip = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_34')]").children.text
        mb.qs = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_63')]").children.text
        mb.sv = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_57')]").children.text
        mb.era = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_47')]").children.text
        mb.whip = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_41')]").children.text
        mb.k9 = @scrape.data.search("//tr[@class='linescoreTeamRow']["+d.to_s+"]/td[contains(@id,'_49')]").children.text

        if(mb.ip.to_i > 0 || mb.runs > 0 || mb.rbi > 0)
          mb.save
        end

      end
    end

    redirect_to sport_path(1)
  end
  def update_teams
  end
end
