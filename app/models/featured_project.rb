class FeaturedProject < ApplicationRecord
  include Ransackable

  validates :title, presence: true
  validates :description, presence: true
  validates :order, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(:order, created_at: :desc) }

  before_create :set_default_order

  def technologies_list
    technologies.present? ? technologies.split(',').map(&:strip) : []
  end

  def has_live_demo?
    live_url.present?
  end

  def has_github?
    github_url.present?
  end

  private

  def set_default_order
    self.order ||= FeaturedProject.maximum(:order).to_i + 1
  end
end
