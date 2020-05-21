require 'bundler'

RACK_ENV = ENV.fetch('RACK_ENV', 'development').to_sym

Bundler.require(:default, RACK_ENV)

$LOAD_PATH.push(__dir__)

require 'models/wall'
if RACK_ENV == :production
  require 'models/lights'
else
  require 'models/dummy_lights'
end

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

  post '/set-brightness' do
    Wall.brightness = params['brightness'].to_i

    status 200
    body ''
  end
end
