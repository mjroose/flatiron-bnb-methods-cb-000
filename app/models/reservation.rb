class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, :through => :listing

  validates :checkin, :presence => true
  validates :checkout, :presence => true
  validate :checkin_time_before_checkout

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    (self.duration * self.listing.price).to_f
  end

  def checkin_time_before_checkout
    if self.checkin < self.checkout
      errors[:checkin] = "must be at least one day before checkout"
    end
  end
end
