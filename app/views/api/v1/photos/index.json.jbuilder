json.data do
  json.array! @photos do |photo|
    # 呼叫 partial
    json.partial! "photo", photo: photo
  end
end

# 第一次的 json.data 會讓回傳資料的 Hash 結構外再包覆一層 { "data": [..] }，
# 這樣的整理會對使用者更加友善。

# json.array! 就是一筆筆取出 @photos 的內容，然後按照你指定的方式來排版，
# 你要求列出的資料是 id、title、description、file_location 等幾個屬性。

