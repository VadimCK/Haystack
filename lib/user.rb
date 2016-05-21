require 'config'
require 'net/ldap'
require 'digest'

class User
    def initialize username
        @username = username
    end

    def use_store store
        @store = store
    end

    def ldap_auth password
        @ldap = Net::LDAP.new
        @ldap.host = Config::LDAP_HOST
        @ldap.port = Config::LDAP_PORT
        !!@ldap.bind_as(
            :base => Config::LDAP_BASE,
            :filter => "(uid=#{@username})",
            :password => password
        )
    end

    def session_key password
        message = "#{@username}:#{password}:#{Config::SESSION_SALT}"
        Digest::SHA256.digest message
    end

    def authorized? password
        return ldap_auth password unless @store
        key = session_key(password)
        return true if @store.active_session? key

        !!(@store.start_session key if ldap_auth password)
    end

    private :ldap_auth ,:session_key
end
