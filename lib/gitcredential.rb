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
    get_payload(set_data) + "password=#{set_data[:password]}\n"
  end

  def get u
    out = nil
    IO.popen("#{cmd} get", mode='r+') { |fd|
      fd.write(get_payload u)
      fd.close_write
      out = fd.read
    }
    return nil if (out.nil? or out.empty?)
    out.sub!(/^password=/, '').chomp
  end

  def set u
    unset(u) unless get(u).nil?
    IO.popen("#{cmd} store", mode='r+') { |fd|
      fd.write(set_payload u)
      fd.close_write
    }
    raise "can't save pw for #{u[:user]}" if get(u).nil?
    true
  end

  def unset u
    return true if get(u).nil?

    IO.popen("#{cmd} erase", mode='r+') { |fd|
      fd.write(get_payload u)
      fd.close_write
    }

    raise "deletion error on #{u[:user]}" unless get(u).nil?
    true
  end
end
