class Skill < ApplicationRecord
  include Ransackable
  
  validates :name, presence: true
  validates :proficiency, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  scope :expert, -> { where('proficiency >= ?', 90) }
  scope :advanced, -> { where(proficiency: 70..89) }
  scope :intermediate, -> { where(proficiency: 50..69) }
  scope :beginner, -> { where('proficiency < ?', 50) }
  scope :ordered, -> { order(proficiency: :desc) }
  
  def proficiency_level
    case proficiency
    when 90..100
      'Expert'
    when 70..89
      'Advanced'
    when 50..69
      'Intermediate'
    else
      'Beginner'
    end
  end
  
  def proficiency_color
    case proficiency
    when 90..100
      '#10b981' # Green
    when 70..89
      '#f59e0b' # Yellow
    when 50..69
      '#f97316' # Orange
    else
      '#ef4444' # Red
    end
  end
end
