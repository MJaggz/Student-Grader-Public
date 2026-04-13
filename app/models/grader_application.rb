class GraderApplication < ApplicationRecord
  belongs_to :user

  has_many :course_preferences, dependent: :destroy
  has_many :courses, through: :course_preferences
  has_many :grader_assignments, dependent: :destroy
  has_many :assigned_sections, through: :grader_assignments, source: :section

  has_many :availabilities, dependent: :destroy

  accepts_nested_attributes_for :availabilities, allow_destroy: true, reject_if: :all_blank
  
  validates :phone_number, presence: true
end
