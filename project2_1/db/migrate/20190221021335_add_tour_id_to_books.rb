class AddTourIdToBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :books, :tour, foreign_key: true
  end
end
