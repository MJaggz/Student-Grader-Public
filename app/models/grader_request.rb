class GraderRequest < ApplicationRecord
  belongs_to :section
  has_many :grader_assignments, through: :section

  validates :request_number, presence: true, uniqueness: true
  validates :requestor_name, presence: true
  validates :num_graders_requested,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :num_graders_assigned,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def fulfilled?
    num_graders_assigned >= num_graders_requested
  end
end