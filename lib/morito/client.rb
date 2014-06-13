require 'uri'

module Morito
  class Client
    def initialize(user_agent)
      @user_agent = user_agent
    end

    def allowed?(requesting_url, cache: true)
      uri = URI.parse(requesting_url)
      robots_txt_body = robots_txt_body(uri, cache: cache)
      Morito::Processor.new(robots_txt_body).allowed?(@user_agent, uri.path)
    end

    private

    def robots_txt_body(uri, cache: true)
      if cache
        with_cache(uri.host) do
          robots_txt_body_without_cache(uri)
        end
      else
        robots_txt_body_without_cache(uri)
      end
    end

    def robots_txt_body_without_cache(uri)
      Morito::Connector.new(uri).get
    end

    def with_cache(host, &block)
      @cache ||= {}
      @cache[host] ||= yield
    end
  end
end
