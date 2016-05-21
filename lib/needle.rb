class Needle
    attr_accessor :name, :mtime, :size

    def initialize(path)
        @path = path
        @name = File.basename(@path)
        @mtime = File.mtime(@path)
        @size = Filesize.from("#{File.size(@path)} B").pretty
    end

    def directory?
        File.directory? @path
    end

    def file?
        File.file? @path
    end

end