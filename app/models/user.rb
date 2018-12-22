class User < ApplicationRecord
  before_save {self.email.downcase!}

  regex_rule_for_password = /\A^(?![\d_.-])[a-zA-Z\.\-\_\d]+@[a-zA-Z]+[.[a-zA-Z]+]+\z/i

  validates :name, presence: true, length: {maximum: 30}
  validates :email, presence: true, length: {maximum: 255}, uniqueness: true, format: {with: regex_rule_for_password}
  validates :password, presence: true, length: {minimum: 8}

  has_secure_password

end
