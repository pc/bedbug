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

post '/receive-commit' do
  push = JSON.parse(params[:payload])
  push['commits'].each do |commit|
    if commit['message'] =~ /#(\d+)/
      b = Bug.from_id($1)
      b.status = 'fixed'
      b.fixed_in = commit['id']
      b.save
    end
  end
end
