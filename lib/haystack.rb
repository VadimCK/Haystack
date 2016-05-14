require 'sinatra/base'
# require 'Haystack/auth/'

class Haystack < Sinatra::Base
    
    get '/' do
        'Hello World!'
    end
    
end
