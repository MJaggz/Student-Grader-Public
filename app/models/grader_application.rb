class GraderApplication < ApplicationRecord
  belongs_to :user
  
  has_many :course_preferences, dependent: :destroy
  has_many :courses, through: :course_preferences

  has_many :availabilities, dependent: :destroy

  # Allows the form to save courses and times simultaneously
  accepts_nested_attributes_for :availabilities, allow_destroy: true
  
  validates :phone_number, presence: true
end