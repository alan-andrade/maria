class Git::CommitsArray
  require 'forwardable'
  extend Forwardable

  # Proxy class to map methods through arrays, not only standalone Commit objects.
  def initialize(array)
    raise ArgumentError, "Provide and array of commits." unless array.nil? or array.kind_of?(Array)
    @array = array
  end

  def files
    @array.map{|c| c.files }.flatten
  end

  def_delegators :@array, :first, :size

end
