class BaseballMatchup < ActiveRecord::Base
  validates :espn_id, presence: true
  validates :week, presence: true

end
