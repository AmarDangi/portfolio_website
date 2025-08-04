class About < ApplicationRecord
    include Ransackable
    
    has_one_attached :photo
    has_one_attached :resume
  end