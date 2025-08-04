class Statistic < ApplicationRecord
  include Ransackable
  
  validates :name, presence: true
  validates :value, presence: true
  validates :category, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :about_stats, -> { where(category: 'about') }
  scope :ordered, -> { order(:order, :name) }
  
  def before_create
    self.order ||= Statistic.where(category: category).maximum(:order).to_i + 1
  end
  
  def display_value
    value
  end
end
