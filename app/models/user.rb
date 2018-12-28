class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {self.email.downcase!}

  regex_rule_for_password = /\A^(?![\d_.-])[a-zA-Z\.\-\_\d]+@[a-zA-Z]+[.[a-zA-Z]+]+\z/i

  validates :name, presence: true, length: {maximum: 30}
  validates :email, presence: true, length: {maximum: 255}, uniqueness: true, format: {with: regex_rule_for_password}
  validates :password, presence: true, length: {minimum: 8}

  has_secure_password

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    self.remember_digest.nil? ? false : BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

end
