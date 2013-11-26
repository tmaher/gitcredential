class Gitcredential

  attr_accessor :backend
  def initialize args = {}
    @backend = args[:backend] || "default"
  end
end
