class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Devise 會運用路由設定裡的 devise_for :users，產生出兩個新的方法
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  # before_create 可以確保在新紀錄「存入資料庫前」一定會觸發這個方法。

  before_create :generate_authentication_token

  def generate_authentication_token
     self.authentication_token = Devise.friendly_token
  end

  def self.from_omniauth(auth)
    # User 不是第一次用 Facebook 登入：因此我們可以用 fb_uid 找到一個現存的 User。
    # Case 1: Find existing user by facebook uid
    user = User.find_by_fb_uid( auth.uid )
    if user
      user.fb_token = auth.credentials.token
      user.save!
      return user
    end

    # User 是第一次用 Facebook 登入，但他也用同一組 email 註冊過帳號：
    # 若是如此，你就可以拿出 Facebook 回傳的 email，從資料庫裡找出一個現存的 User。

    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    if existing_user
      existing_user.fb_uid = auth.uid
      existing_user.fb_token = auth.credentials.token
      existing_user.save!
      return existing_user
    end

    # User 沒有註冊過，且是第一次用 Facebook 登入：若是如此，你需要建立一個全新的 User 紀錄。
    # Case 3: Create new password
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.save!
    return user
  end

end
