class AddPasswordDigestToUsers < ActiveRecord::Migration[5.2]
# この属性を与えることでモデル内でhas_secure_password機能が使える
  def change
    add_column :users, :password_digest, :string
  end
end
