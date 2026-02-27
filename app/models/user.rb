class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { student: 0, instructor: 1, admin: 2 }

  validates :email, format: { with: /\A[a-zA-Z]+\.\d+@osu\.edu\z/,
                              message: "must be in name.#@osu.edu format" }
 private

  def approve_students
    self.approved = true if self.student?
  end
end
