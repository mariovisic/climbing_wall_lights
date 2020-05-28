require 'bundler'

RACK_ENV = ENV.fetch('RACK_ENV', 'development').to_sym

Bundler.require(:default, RACK_ENV)

$LOAD_PATH.push(__dir__)

require 'sinatra'
require 'database'

require 'models/wall'
require 'models/route'
if RACK_ENV == :production
  require 'models/lights'
else
  require 'models/dummy_lights'
end

Wall.play_boot_sequence

class ClimbingWallLightsApplication < Sinatra::Base
  get '/' do
    erb :homepage
  end

  get '/routes' do
    erb :routes, locals: { routes: Route.all }
  end

  get '/routes/new' do
    Wall.turn_all_off

    erb :new_route
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
