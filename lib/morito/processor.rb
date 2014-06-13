module Morito
  class Processor
    def initialize(body)
      @body = body || ''
    end

    def allowed?(user_agent, path)
      disallows = disallows_for(user_agent)

      if disallows.empty?
        true
      else
        regexp = Regexp.new("\\A(?:#{disallows.join('|')})")
        regexp !~ path
      end
    end

    private

    def disallows_for(user_agent)
      build

      if !@disallows[user_agent].empty?
        @disallows[user_agent]
      else
        @disallows['*']
      end
    end

    def build
      return if @disallows
      @disallows = Hash.new {|h, k| h[k] = [] }

      parser = LineParser.new
      @body.split(/\n+/).each do |line|
        parser.parse(line)
        @disallows[parser.user_agent] << parser.disallow if parser.disallow?
      end

      @disallows
    end

    class LineParser
      attr_reader :user_agent, :disallow

      def parse(line)
        case line
        when /\AUser-agent:\s+(.+?)\s*(?:#.+)?\z/i
          @user_agent = $1
          @disallow = nil
        when /\ADisallow:\s+(.+?)\s*(?:#.+)?\z/i
          @disallow = $1
        else
          @disallow = nil
        end
      end

      def disallow?
        @user_agent && @disallow
      end
    end
  end
end
