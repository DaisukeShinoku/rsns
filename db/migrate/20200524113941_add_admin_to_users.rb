class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
  	# コードの意図(デフォでは管理者権限は与えない)を明確に示すためのdefault: false、なくても平気
    add_column :users, :admin, :boolean, default: false
  end
end
