require 'faraday'
require 'uri'

module Morito
  class Connector
    PATH = '/robots.txt'

    attr_reader :uri

    def initialize(uri, cache: true)
      @uri = uri
      @cache = cache
    end

    def get
      if @cache
        self.class.with_cache(base_url) do
          raw_get
        end
      else
        raw_get
      end
    end

    private

    def self.with_cache(base_url, &block)
      @cache ||= {}
      @cache[base_url] ||= yield
    end

    def raw_get
      @get ||= connection.get(PATH).body
    end

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
