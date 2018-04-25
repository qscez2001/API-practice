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



end
