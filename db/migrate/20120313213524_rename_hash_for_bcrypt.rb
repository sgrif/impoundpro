class RenameHashForBcrypt < ActiveRecord::Migration
  def change
    rename_column :users, :hashed_password, :password_digest
  end
end
