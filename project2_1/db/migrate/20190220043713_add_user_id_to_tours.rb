class AddUserIdToTours < ActiveRecord::Migration[5.2]
  def change
    add_reference :tours, :user, foreign_key: true
  end
end
