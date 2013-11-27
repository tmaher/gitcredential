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
    @search_dft = {:proto => "https", :path => "/"}
    @backend = args[:backend] || Gitcredential.default_backend

    raise Exception "no such backend" unless @valid_backends.include?(@backend)
  end

  def cmd
    "git-credential-#{@backend}"
  end

  def get_payload search_data={}
    u = @search_dft.merge search_data
    <<-__EOS
protocol=#{u[:proto]}
host=#{u[:host]}
path=#{u[:path]}
username=#{u[:user]}
__EOS
  end

  def set_payload set_data={}
    get_payload(set_data) + "password=#{set_data[:pw]}\n"
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
