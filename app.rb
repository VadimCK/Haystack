require 'sinatra/base'
require 'erubis'
require 'filesize'

$LOAD_PATH << 'lib'
require 'config'
require 'stack'
require 'user'
require 'session_store'

class HayStack < Sinatra::Base
    include ERB::Util

    use Rack::Sendfile
    set :static, true
    set :erb, :escape_html => true

    session_store = SessionStore.new

    # Enable Basic Auth if LDAP mode is set
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
        return false if username.empty? or password.empty?

        user = User.new username
        user.use_store session_store
        user.authorized? password
    end if Config::AUTH_MODE == :ldap

    get '/*' do |path|
        @title = "Index of /#{path}"
        @web_path = path
        fs_path = Stack.safe_path path

        if File.file? fs_path
            send_file fs_path

        elsif File.directory? fs_path
            redirect to("#{@web_path}/") unless @web_path.end_with? '/' or @web_path.empty?
            @dir_list = Stack.needles fs_path
            erb :dir_list

        else
            @title='404 Not Found'
            status 404
            erb :"#{404}" 
        end
    end

    at_exit do
        session_store.close
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
end
