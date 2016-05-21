require 'daybreak'
require 'config'

class SessionStore
    def initialize
        @db = Daybreak::DB.new Config::DB_SESSION
    end
    
    def start_session session_key, ttl=900
        @db.synchronize do
            @db[session_key] = Time.now.to_i+ttl
            @db.flush
        end
    end

    def active_session? session_key
        # Reload store from file if we expect this method to fail.
        # This is the only way to get daybreak to sync sessions across threads
        if (not @db.has_key? session_key) or @db[session_key] <= Time.now.to_i
            @db.load
        end

        return false unless @db.has_key? session_key
        @db[session_key] > Time.now.to_i
    end

    def close
        @db.compact
        @db.close
    end

end
