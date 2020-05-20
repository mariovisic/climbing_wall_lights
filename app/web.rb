require 'bundler'
Bundler.require

$LOAD_PATH.push(__dir__)

require 'models/wall'
require 'models/lights'

class ClimbingWallLightsApplication < Sinatra::Base
  get '/' do
    erb :homepage
  end

  post '/toggle-light/:x/:y' do
    Wall.toggle(params[:x], params[:y])

    status 200
    body ''
  end

  post '/lights-off' do
    Wall.turn_all_off


    redirect '/'
  end

  post '/lights-on' do
    Wall.turn_all_on


    redirect '/'
  end

end
