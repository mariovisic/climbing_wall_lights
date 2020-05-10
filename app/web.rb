require 'bundler'
Bundler.require

class ClimbingWallLightsApplication < Sinatra::Base
  get '/' do
    "Hello World!"
  end
end
