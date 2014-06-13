require 'uri'

module Morito
  class Client
    def initialize(user_agent)
      @user_agent = user_agent
    end

    def allowed?(requesting_url, cache: true)
      uri = URI.parse(requesting_url)
      robots_txt_body = Morito::Connector.new(uri, cache: cache).get
      Morito::Processor.new(robots_txt_body).allowed?(@user_agent, uri.path)
    end
  end
end
