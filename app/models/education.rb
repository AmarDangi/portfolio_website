class Education < ApplicationRecord
  include Ransackable

  validates :degree, presence: true
  validates :institution, presence: true
  validates :start_date, presence: true
  validates :gpa, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10.0 }, allow_nil: true

  scope :current, -> { where(current: true) }
  scope :completed, -> { where(current: false) }
  scope :ordered, -> { order(start_date: :desc) }

  def duration
    if current
      "#{start_date.strftime('%Y')} - Present"
    elsif end_date
      "#{start_date.strftime('%Y')} - #{end_date.strftime('%Y')}"
    else
      start_date.strftime('%Y')
    end
  end

  def gpa_display
    gpa ? "GPA: #{gpa}/10.0" : nil
  end
end
