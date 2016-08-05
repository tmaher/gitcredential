require 'socket'
require 'uri'

# Gitcredential::Cache
# A native ruby client for talking to git-credential-cache (no shelling out!)
class Gitcredential::Cache
  ATTRIBUTES     = [:url, :protocol, :host, :path,
                    :username, :password, :timeout].freeze
  DEFAULT_SOCKET = "#{ENV['HOME']}/.git-credential-cache/socket".freeze
  DEFAULT_TTL    = 900
  JAN_2038       = 2147483600

  def initialize socket: DEFAULT_SOCKET, timeout: DEFAULT_TTL
    @cache = UNIXSocket.new socket
    @ttl = timeout
  end

  def get cred
    @cache.send cmd_string(:get, cred)
    @cache.recv
  end

  def store cred
    @cache.send cmd_string(:store, cred)
  end

  def erase cred
    @cache.send cmd_string(:erase, cred)
  end

  def exit!
    @cache.send cmd_string(:exit, {})
    @cache.shutdown
    @cache = nil
  end

private

  def cmd_string action, cred
    (["action=#{action}",
      get_timeout(cred)] +
      credential_strings(cred)
    ).join "\n"
  end

  def credential_strings cred
    validate_cred! cred
    strings = []
    strings << "url=#{cred[:url]}" if cred[:url]
    cred.each { |k,v| strings << "#{k}=#{v}" unless k == :url }

    strings
  end

  def get_timeout cred={}
    "timeout=#{cred[:timeout] || @ttl || JAN_2038 - Time.now.to_i}"
  end

  def validate_cred! cred
    bad_attrs = cred.keys.reject { |k| ATTRIBUTES.include? k.to_sym }
    unless bad_attrs.empty?
      raise ArgumentError.new(
        "Bogus credential attributes: #{bad_attrs.join ','}.  " \
        "Valid attrs: #{ATTRIBUTES.join ','}."
      )
    end
  end
end
