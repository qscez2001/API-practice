class Api::V1::AuthController < ApiController
  # 確保要先登入，才會請求登出。
  before_action :authenticate_user!, only: :logout

  # 當 client 端送出「登入」請求，並附上帳號密碼，server 端驗證後回傳 token 參數，
  # client 端與 server 端的 token 相同，可以通過 authenticate_user_from_token! 的驗證。

  # 而一旦 client 端請求「登出」，server 會刷新 token 但不回傳，兩邊 token 不一致，因此不會通過 authenticate_user_from_token! 的驗證。


  # POST /api/v1/login
  def login
    if params[:email] && params[:password]
      user = User.find_by_email(params[:email])
    end

    if user && user.valid_password?(params[:password])
      render json: {
        message: "Ok",
        auth_token: user.authentication_token,
        user_id: user.id
      }
    else
      render json: { message:  "Email or Password is wrong" }, status:  401
    end
  end

  # 如果客戶端拿舊的 token 發出 HTTP request，在通過 ApiController 時，
  # 在 authenticate_user_from_token 裡會找不到對應的 User 物件，因此就不會登入。
  # POST /api/v1/logout
  def logout
    # 登入時刷新 token，做為下次登入時比對用，而舊的 token 就失效了
    current_user.generate_authentication_token
    current_user.save!

    render json: { message:  "Ok" }
  end

end
