class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # #update team names
  def update_teams
    @name_scrape = BaseballScraper.new('http://games.espn.go.com/flb/standings?leagueId=2735&seasonId=2016')

    data_teams = @name_scrape.data.css('#content > div > div.gamesmain.container > div > div > div > table:nth-child(2) > tr > td > table > tr > td > a')

    Member.delete_all
    Member.reset_pk_sequence
    data_teams.each do |t|
      Member.create(name: t.text, ESPN_id: t.attr("href").partition('teamId=').last.partition('&').first)
    end

    redirect_to root_path
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.all
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.fetch(:member, {})
    end
end
