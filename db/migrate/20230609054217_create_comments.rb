class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :prototype, null: false, unique: true
      t.references :user, null: false, unique: true, dependent: :destroy

      t.timestamps
    end
  end
end
