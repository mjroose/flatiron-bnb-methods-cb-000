class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, :through => :listing

  validates :checkin, :presence => true
  validates :checkout, :presence => true
  validate :checkin_time_before_checkout
  validate :available

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    (self.duration * self.listing.price).to_f
  end

  def checkin_time_before_checkout
    if self.checkin != nil && self.checkout != nil && self.checkin >= self.checkout
      errors[:checkin] = "must be at least one day before checkout"
    end
  end

  def available
    if self.checkin && self.checkout && !already_booked?
      errors[:reservation] = "cannot already be booked"
    end
  end

  def already_booked?
    !!(self.listing.reservations.detect do |reservation|
      reservation.checkin < self.checkout && reservation.checkout > self.checkin
    end)
  end
end
