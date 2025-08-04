class Experience < ApplicationRecord
  include Ransackable
  
  validates :title, presence: true
  validates :company, presence: true
  validates :start_date, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :current, -> { where(current: true) }
  scope :past, -> { where(current: false) }
  scope :ordered, -> { order(:order, start_date: :desc) }
  
  def duration
    if current?
      "#{start_date.strftime('%B %Y')} - Present"
    else
      "#{start_date.strftime('%B %Y')} - #{end_date.strftime('%B %Y')}"
    end
  end
  
  def years_experience
    end_date = self.current? ? Date.current : self.end_date
    ((end_date - start_date).to_i / 365.25).round(1)
  end
  
  def before_create
    self.order ||= Experience.maximum(:order).to_i + 1
  end
end
