# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  last_name           :string
#  email               :string
#  email_confirm       :boolean
#  email_confirm_token :string
#  password_digest     :string
#  remember_digest     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class User < ApplicationRecord
  validates :first_name,  presence: true, length: { minimum: 1, maximum: 100 }
  validates :last_name,  presence: true, length: { minimum: 1, maximum: 100 }

  validates :email, presence: true, length: { maximum: 300 },
                    format: { with: /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates_confirmation_of :password

  def forget
    update_attribute(:remember_digest, nil)
  end
end
