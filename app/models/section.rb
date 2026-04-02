class Section < ApplicationRecord
  belongs_to :course

  scope :ordered_for_catalog, -> { order(term: :desc, section_number: :asc, class_number: :asc) }
  scope :with_term, ->(term) { term.present? ? where(term: term) : all }

  validates :term, presence: true
  validates :section_number, presence: true, uniqueness: { scope: [:course_id, :term] }
end
