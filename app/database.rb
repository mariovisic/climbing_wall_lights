require 'sinatra/sequel'

set :database, 'sqlite://climbing_wall_lights.db'

migration "create the routes table" do
  database.create_table :routes do
    primary_key :id
    string :title, null: false
    integer :difficulty
    text :wall_state, null: false
    text :notes
    timestamp :created_at, null: false
    timestamp :updated_at, null: false
  end
end


