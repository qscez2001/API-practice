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

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      render json: {
        message: "Photo created successfully!",
        result: @photo
      }
    else
      render json: {
        errors: @photo.errors
      }
    end
  end

  def update
    @photo = Photo.find_by(id: params[:id])
    if @photo.update(photo_params)
      render json: {
        message: "Photo updated successfully!",
        result: @photo
      }
    else
      render json: {
        errors: @photo.errors
      }
    end
  end

  def destroy
    @photo = Photo.find_by(id: params[:id])
    @photo.destroy
    render json: {
      message: "Photo destroy successfully!"
    }
  end

  private

  # 之前搭配 form_for 時，需要在中間加一層 require(:photo)，
  # 那是因為 form_for 回傳的 Hash 結構會在最外層打包一層 photo: {.....}，
  # 但由於 API 回傳的參數結構是你定義的 JSON 結構，你可以在 Server Log 裡觀察
  def photo_params
    params.permit(:title, :date, :description, :file_location)
  end

end
