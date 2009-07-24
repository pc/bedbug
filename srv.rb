#!/usr/bin/ruby
require File.join(File.dirname(__FILE__), 'bedbug')
require 'sinatra'

set :host, '127.0.0.1'
set :port, 1223

get '/' do
  @bugs = Bug.all
  @baseurl = $config['baseurl']
  erb :index
end

get '/bug/:id' do
  @bug = Bug.from_id(params[:id])
  erb :bug
end

post '/receive-commit' do
  push = JSON.parse(params[:payload])
  push['commits'].each do |commit|
    
    b = nil
    if commit['message'] =~ /#(\d+)/
      b = Bug.from_id($1)
    elsif commit['message'] =~ /#(\w+)/
      b = Bug.from_tag($1)
    end

    if b
      b.status = 'fixed'
      b.fixed_in = commit['id']
      b.save
    end
  end
  'ok'
end
