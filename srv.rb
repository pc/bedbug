require File.join(File.dirname(__FILE__), 'microbug')
require 'sinatra'

set :port, 1223

get '/' do
  @bugs = Bug.all
  erb :index
end

get '/bug/:id' do
  @bug = Bug.from_id(params[:id])
  erb :bug
end
