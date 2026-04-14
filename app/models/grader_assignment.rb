class GraderAssignment < ApplicationRecord
  belongs_to :section
  belongs_to :grader_application
  validates :grader_application_id, uniqueness: { scope: :section_id }

  before_create :set_assigned_at

  private

  def set_assigned_at
    self.assigned_at ||= Time.current
  end
end
