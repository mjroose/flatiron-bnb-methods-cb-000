class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, :through => :listing

  validates :checkin, :presence => true
  validates :checkout, :presence => true

  def duration
    (self.checkout - self.checkin).to_i
  end
end
