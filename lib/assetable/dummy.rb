module Assetable::Dummy
  include Assetable::Template

  def asset_type
    :dummy
  end

  def max_size
    0
  end

  def extension
    'dummyext'
  end

end
