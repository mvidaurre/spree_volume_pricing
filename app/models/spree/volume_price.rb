class Spree::VolumePrice < ActiveRecord::Base
  belongs_to :volume_price_model, :touch => true
  acts_as_list :scope => :volume_price_model

  validates :amount, :presence => true
  validates :discount_type, :presence => true, :inclusion => {:in => %w(price dollar percent), :message => "%{value} is not a valid Volume Price Type"}
  validates :range, :format => {:with => /\(?[0-9]+(?:\.{2,3}[0-9]+|\+\)?)/, :message => "must be in one of the following formats: (a..b), (a...b), (a+)"}
  validates :volume_price_model, :presence => true

  OPEN_ENDED = /\(?[0-9]+\+\)?/

  def include?(quantity)
    if open_ended?
      bound = /\d+/.match(range)[0].to_i
      return quantity >= bound
    else
      range.to_range === quantity
    end
  end

  # indicates whether or not the range is a true Ruby range or an open ended range with no upper bound
  def open_ended?
    OPEN_ENDED =~ range
  end
end
