class Availability < ApplicationRecord
  belongs_to :grader_application

  DAYS = %w[Monday Tuesday Wednesday Thursday Friday].freeze

  validates :day, presence: true
  validates :day, inclusion: { in: DAYS }, allow_blank: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    return if end_time > start_time

    errors.add(:end_time, "must be after start time")
  end
end
