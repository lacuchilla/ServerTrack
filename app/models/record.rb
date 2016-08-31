class Record < ApplicationRecord
  validates :cpu, :presence => true
  validates :ram, :presence => true
  validates :server_id, :presence => true

  def next
    self.class.where("created_at < ?", created_at)
  end
end
