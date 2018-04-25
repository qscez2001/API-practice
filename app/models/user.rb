class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # before_create 可以確保在新紀錄「存入資料庫前」一定會觸發這個方法。

  before_create :generate_authentication_token

  def generate_authentication_token
     self.authentication_token = Devise.friendly_token
  end

end
