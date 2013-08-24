require 'sinatra'

get '/' do
  'Hello world!'
end

get '/random' do
  "This is a random string: #{(0...10).map{ ('a'..'z').to_a[rand(26)] }.join}"
end
