class Record < ApplicationRecord
  def next
    self.class.where("created_at < ?", created_at)
  end
end
