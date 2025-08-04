class Certification < ApplicationRecord
  include Ransackable

  validates :name, presence: true
  validates :issuer, presence: true
  validates :issue_date, presence: true

  scope :active, -> { where('expiry_date IS NULL OR expiry_date >= ?', Date.current) }
  scope :expired, -> { where('expiry_date < ?', Date.current) }
  scope :ordered, -> { order(issue_date: :desc) }

  def status
    if expiry_date.nil?
      'No Expiry'
    elsif expiry_date >= Date.current
      'Active'
    else
      'Expired'
    end
  end

  def status_color
    case status
    when 'Active', 'No Expiry'
      'green'
    when 'Expired'
      'red'
    else
      'gray'
    end
  end

  def validity_period
    if expiry_date
      "#{issue_date.strftime('%B %Y')} - #{expiry_date.strftime('%B %Y')}"
    else
      "Issued #{issue_date.strftime('%B %Y')} (No Expiry)"
    end
  end
end
