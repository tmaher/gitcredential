class Gitcredential

  def self.default_backend
    case RUBY_PLATFORM
    when /-darwin[\d\.]+\z/
      "osxkeychain"
    when /win32/
      "winstore"
    else
      "cache"
    end
  end

  attr_accessor :backend
  def initialize args = {}
    @valid_backends = ["osxkeychain", "winstore", "cache", "store", "default"]
    @backend = args[:backend] || Gitcredential.default_backend

    raise Exception "no such backend" unless @valid_backends.include?(@backend)
  end

  def cmd
    "git-credential-#{backend}"
  end
    
  def get u
    nil
  end

  def set u
    nil
  end

  def unset u
    nil
  end


end
