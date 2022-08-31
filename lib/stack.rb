require 'config'
require 'needle'
require 'uri'

class Stack

    def self.needles fs_path
        exclude = ['.', '..']
        entries = Dir.entries(fs_path).reject {|e| exclude.include? e}.sort!
        entries.map {|e| Needle.new File.expand_path(e, fs_path)}
    end

    def self.safe_path path
        absolute_path = File.expand_path(path, Config::ROOT_DIR)
        raise "Error: Path traversal attack attempted." unless absolute_path.start_with? Config::ROOT_DIR
        absolute_path
    end

end
