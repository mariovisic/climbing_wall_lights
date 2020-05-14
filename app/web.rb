require 'bundler'
Bundler.require

$LOAD_PATH.push(__dir__)

require 'models/wall'

class ClimbingWallLightsApplication < Sinatra::Base
  get '/' do
    erb :homepage
  end

  post '/toggle-light/:x/:y' do
    Wall.toggle(params[:x], params[:y])

    status 200
    body ''
  end
end
