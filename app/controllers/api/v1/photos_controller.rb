class Api::V1::PhotosController < ApiController

  # 我們只打算公開 title、data、description 這幾個屬性

  # 重新輸出 @photos 裡面的陣列，這時候會用到 map 方法，map 方法專門用於映射新陣列
  def index
    @photos = Photo.all
    render json: {
      data: @photos.map do |photo|
        {
          title: photo.title,
          date: photo.date,
          description: photo.description
        }
      end
    }
  end

  def show
    # find_by 方法在找不到物件內容時，會回傳 nil
    # HTTP 狀態碼 400，意即「Bad Request」，表示客戶端的請求無效
    @photo = Photo.find_by(id: params[:id])
    if !@photo
      render json: {
        message: "Can't find the photo!",
        status: 400
      }
    else
      render json: {
        title: @photo.title,
        date: @photo.date,
        description: @photo.description
      }
    end
  end

end
