require 'faraday'

module Morito
  class Connector
    PATH = '/robots.txt'

    def initialize(uri)
      @uri = uri
    end

    def get
      @get ||= connection.get(PATH).body
    end

    private

    def connection
      Faraday.new(url: base_url) do |connection|
        connection.adapter :net_http
      end
    end

    def base_url
      "#{@uri.scheme}://#{@uri.host}:#{@uri.port}"
    end
  end
end
