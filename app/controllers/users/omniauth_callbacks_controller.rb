class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # 透過 Facebook 回傳的資訊，比對現有資料庫裡的 User 紀錄，看看是否能找出一個既成的 User。
  # （request.env["omniauth.auth"] 會用 Hash 形式攜帶 Facebook 回傳的資訊，但 from_omniauth 需要去 User Model 裡手工加入）
  
  # 如果該 User 物件被找出來了，就呼叫 Devise 方法使該 User 物件登入，並閃過 flash message 提示。
  # 如果該 User 物件不存在，就把 Facebook 回傳的資料丟進 Devise 的註冊方法，在本地資料庫建立一個新的 User
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

end