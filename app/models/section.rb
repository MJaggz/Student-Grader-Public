class Section < ApplicationRecord
  belongs_to :course
  has_one :grader_request, dependent: :destroy

  has_many :grader_assignments, dependent: :destroy
  has_many :assigned_grader_applications, through: :grader_assignments, source: :grader_application

  scope :ordered_for_catalog, -> { order(term: :desc, section_number: :asc, class_number: :asc) }
  scope :with_term, ->(term) { term.present? ? where(term: term) : all }

  validates :term, presence: true
  validates :section_number, presence: true, uniqueness: { scope: [:course_id, :term] }
  validates :days, presence: true
  validates :times, presence: true
  validates :class_number, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :credit_hours, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
end