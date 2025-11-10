require "net/http"
require "uri"
require "openssl"

module Tempo
  class Error < StandardError; end

  class Client
    DEFAULT_BASE_URL = "https://ihelp.rt.ru".freeze

    def initialize(login:, password:, base_url: ENV.fetch("TEMPO_BASE_URL", DEFAULT_BASE_URL))
      @login = login
      @password = password
      @base_url = base_url
    end

    def get(path)
      uri = URI.join(@base_url, path)
      request = Net::HTTP::Get.new(uri)
      request.basic_auth(@login, @password)
      perform(uri, request)
    end

    private

    def perform(uri, request)
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        verify_mode: OpenSSL::SSL::VERIFY_NONE
      ) do |http|
        response = http.request(request)
        raise Tempo::Error, "Tempo API error: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)
        response
      end
    end
  end
end
