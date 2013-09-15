class ScanContext
  attr_accessor :browser, :data

  def get_binding
    return binding()
  end
end