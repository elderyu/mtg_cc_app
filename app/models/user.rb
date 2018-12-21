class User < ApplicationRecord
before_save {self.email.downcase!}

regex_rule_for_password = /^(?![\d_.-])[a-zA-Z\.\-\_\d]+@[a-zA-Z]+[.[a-zA-Z]+]+/i

validates :name, presence: true, length: {maximum: 30}
validates :email, presence: true, length: {maximum: 255}, uniqueness: true, format: {with: regex_rule_for_password}

has_secure_password

end
