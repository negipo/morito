module Morito
  class Processor
    def initialize(body)
      @body = body || ''
    end

    def allowed?(user_agent, path)
      if !disallows_regexp(user_agent)
        true
      else
        if allows_regexp(user_agent) && allows_regexp(user_agent) =~ path
          true
        else
          disallows_regexp(user_agent) !~ path
        end
      end
    end

    private

    def allows_regexp(user_agent)
      allows = allows_for(user_agent)

      if allows.empty?
        nil
      else
        Regexp.new("\\A(?:#{allows.join('|')})")
      end
    end

    def disallows_regexp(user_agent)
      disallows = disallows_for(user_agent)

      if disallows.empty?
        nil
      else
        Regexp.new("\\A(?:#{disallows.join('|')})")
      end
    end

    def allows_for(user_agent)
      build

      if !@allows[user_agent].empty?
        @allows[user_agent]
      else
        @allows['*']
      end
    end

    def disallows_for(user_agent)
      build

      if !@disallows[user_agent].empty?
        @disallows[user_agent]
      else
        @disallows['*']
      end
    end

    def build
      return if @builded

      @disallows = Hash.new {|h, k| h[k] = [] }
      @allows = Hash.new {|h, k| h[k] = [] }

      parser = LineParser.new
      @body.split(/\n+/).each do |line|
        parser.parse(line)
        @disallows[parser.user_agent] << parser.disallow if parser.disallow?
        @allows[parser.user_agent] << parser.allow if parser.allow?
      end

      @builded = true
    end

    class LineParser
      attr_reader :user_agent

      def parse(line)
        case line
        when /\AUser-agent:\s+(.+?)\s*(?:#.+)?\z/i
          @user_agent = $1
          clear_permissions
        when /\ADisallow:\s+(.+?)\s*(?:#.+)?\z/i
          @disallow = $1
        when /\AAllow:\s+(.+?)\s*(?:#.+)?\z/i
          @allow = $1
        else
          clear_permissions
        end
      end

      def allow
        pattern_for(@allow)
      end

      def disallow
        pattern_for(@disallow)
      end

      def allow?
        @user_agent && @allow
      end

      def disallow?
        @user_agent && @disallow
      end

      private

      def pattern_for(string)
        Regexp.escape(string).gsub('\*', '.*').gsub('\$', '$')
      end

      def clear_permissions
        @disallow = nil
        @allow = nil
      end
    end
  end
end
