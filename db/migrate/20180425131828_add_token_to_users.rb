class AddTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    # 我們在新增欄位時，同時加上索引 (index)，使用索引的 :unique 參數來確保 authentication_token 的值不會重複。
    # 這是資料庫層級的驗證，即使 Model 通過驗證，資料庫層沒通過，還是無法存入資料庫。

    add_column :users, :authentication_token, :string
    add_index :users, :authentication_token, :unique => true

    User.find_each do |user|
      user.generate_authentication_token
      user.save!
      puts "generate user #{user.id} token"
    end
  end
end
