module Git
  class Status

    # x: Status of the file in the index.
    # y: Status of the file in the Working tree.
    # filename: File's name
    attr_reader :x, :y, :filename

    def initialize(x, y, filename)
      @x = x
      @y = y
      @filename = filename
    end

    # in_wt?
    #
    # Means: in working tree?
    #
    # This will check the Y attribute and verify that the file is under our
    # working tree.
    def in_wt?
      !!@y.match(/[ MD]/)
    end

    # in_index?
    #
    # Means: Is the file staged?
    #
    # Will verify the status with the X attribute
    def in_index?
      !!@x.match(/[ MARC]/)
    end

    # get
    #
    # Interface to generate a new status based on a file.
    def self.get(file_path)
      Git::StatusParser.parse( Git::Run.status(file_path) )
    end

  end #/Status
end
