class AddManagerToCollaborator < ActiveRecord::Migration[6.1]
  def change
    add_reference :collaborators, :manager, null: true, foreign_key: false
  end
end
