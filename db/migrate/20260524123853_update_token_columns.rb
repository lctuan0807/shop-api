class UpdateTokenColumns < ActiveRecord::Migration[7.2]
  def change
    rename_column :tokens, :refresh_token, :refresh_token_used
    add_column :tokens, :refresh_token, :string
  end
end
