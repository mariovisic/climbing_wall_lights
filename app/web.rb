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

class ClimbingWallLightsApplication < Sinatra::Base
  set method_override: true

  get '/' do
    erb :homepage
  end

  get '/routes' do
    erb :routes, locals: { routes: Route.all }
  end

  get '/routes/new' do
    route = Route.new(title: [Spicy::Proton.adjective(max: 8).capitalize, FFaker::AnimalUS.common_name].join(' '))

    erb :new_route, locals: { route: route }
  end

  get '/routes/:id/load' do
    route = Route.find(id: params[:id])
    Wall.load(route)

    redirect '/routes'
  end

  get '/routes/:id/edit' do
    route = Route.find(id: params[:id])
    Wall.load(route)

    erb :edit_route, locals: { route: route }
  end

  post '/routes' do
    Route.create(params[:route])

    redirect '/routes'
  end

  put '/routes/:id' do
    Route.find(id: params[:id]).update(params[:route])

    redirect '/routes'
  end

  delete '/routes/:id' do
    Route.find(id: params[:id]).delete

    redirect '/routes'
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

  post '/toggle-power' do
    Wall.toggle_power

    redirect '/'
  end
end
