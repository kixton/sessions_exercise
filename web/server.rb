require 'sinatra'
require_relative '../config/environments.rb'

module Sessions
  class Server < Sinatra::Application
    configure do
      set :bind, '0.0.0.0'
      enable :sessions
    end

    get '/' do
      # session treated like a hash
      if session[:user_id]
        erb :index
      else
        redirect to('/login')
      end
    end

    
    get '/signup' do
      erb :signup
    end

    post '/users' do
      if params[:password] == params[:password_confirmation]
        hashed_password = User.encrypt_password(params[:password])
        user = User.create(username: params[:username], password_hash: hashed_password)
        # login upon creation
        # session[:user_id] = user.id
      end
      redirect to('/')
    end

    get '/login' do
      erb :login
    end

    # creates a new session
    post '/sessions' do
      user = User.find_by(username: params[:username])
      if user.validate_password(params[:password])
        session[:user_id] = user.id
      end

      redirect to('/')
    end

    delete '/logout' do
      session[:user_id] = nil
      redirect to('/')
    end
  end
end

