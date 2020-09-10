require 'bundler'

RACK_ENV = ENV.fetch('RACK_ENV', 'development').to_sym

Bundler.require(:default, RACK_ENV)

$LOAD_PATH.push(__dir__)

require 'sinatra'
require 'database'

require 'models/wall'
require 'models/route'
require 'models/route_generator'
if RACK_ENV == :production
  require 'models/lights'
else
  require 'models/dummy_lights'
end

class ClimbingWallLightsApplication < Sinatra::Base
  set method_override: true

  before '/*' do
    if !Wall.powered_on && !([[''], ['toggle-power']].include?(params[:splat]))
      redirect '/'
    end
  end

  get '/' do
    erb :homepage
  end

  get '/routes' do
    erb :routes, locals: { routes: Route.to_hash_groups(:difficulty) }
  end

  get '/routes/new' do
    route = Route.new(title: [Spicy::Proton.adjective(max: 8).capitalize, FFaker::AnimalUS.common_name].join(' '))

    erb :new_route, locals: { route: route }
  end

  get '/routes/:id/load' do
    route = Route.find(id: params[:id])
    Wall.load(JSON.load(route.wall_state))

    redirect '/routes'
  end

  get '/routes/:id/edit' do
    route = Route.find(id: params[:id])
    Wall.load(JSON.load(route.wall_state))

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

  get '/game/new' do
    erb :new_game
  end

  post '/game' do
    erb :game, locals: { speed: params[:speed] }
  end

  put '/game' do
    Wall.turn_random_red(params[:speed])

    erb :game, locals: { speed: params[:speed] }
  end

  post '/game/reset' do
    Wall.turn_all_off

    erb :game, locals: { speed: params[:speed] }
  end

  post '/set-light/:x/:y' do
    Wall.set(params[:x], params[:y], params[:state])

    status 200
    body ''
  end

  get '/route-generator/new' do
    erb :new_route_generator
  end

  post '/route-generator' do
    Wall.load(RouteGenerator.generate(params[:difficulty]))

    erb :new_route_generator, locals: { difficulty: params[:difficulty] }
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
