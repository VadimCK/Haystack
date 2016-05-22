#This can be improved, possibly using ruby module config pattern
class Config
    ROOT_DIR = '/home/downloads'

    LDAP_HOST = 'localhost'
    LDAP_PORT = '389'
    LDAP_BASE = 'ou=People,dc=meisley,dc=com'

    DB_SESSION = 'db/session.db'

    SESSION_SALT = '<change_me>'

    HTTP_BASE = ''
end