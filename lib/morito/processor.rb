module Morito
  class Processor
    def initialize(body)
      @body = body || ''
    end

    def allowed?(user_agent, path)
      UserAgentPermission.new(user_agent, whole_permission).allowed?(path)
    end

    private

    def whole_permission
      return @whole_permission if @whole_permission

      @whole_permission = Hash.new {|h, k| h[k] = Hash.new {|h2, k2| h2[k2] = [] } }
      parser = LineParser.new

      @body.split(/\n+/).each do |line|
        parser.parse(line)
        if parser.disallow?
          @whole_permission[parser.user_agent][:disallow] << parser.disallow
        elsif parser.allow?
          @whole_permission[parser.user_agent][:allow] << parser.allow
        end
      end

      @whole_permission
    end

    class UserAgentPermission
      def initialize(user_agent, whole_permission)
        @user_agent = user_agent

        if whole_permission[user_agent].empty?
          @permission = whole_permission['*']
        else
          @permission = whole_permission[user_agent]
        end
      end

      def allowed?(path)
        return true if disallow_unavailable?

        if !allow_unavailable? && regexp(:allow) =~ path
          true
        else
          regexp(:disallow) !~ path
        end
      end

      private

      def allow_unavailable?
        @permission[:allow].empty?
      end

      def disallow_unavailable?
        @permission[:disallow].empty?
      end

      def regexp(type)
        raw_regexps = @permission[type].map do |permission|
          Regexp.escape(permission).gsub('\*', '.*').gsub('\$', '$')
        end

        Regexp.new("\\A(?:#{raw_regexps.join('|')})")
      end
    end

    class LineParser
      attr_reader :user_agent, :allow, :disallow

      def parse(line)
        clear_permissions

        case line
        when /\AUser-agent:\s+(.+?)\s*(?:#.+)?\z/i
          @user_agent = $1
        when /\ADisallow:\s+(.+?)\s*(?:#.+)?\z/i
          @disallow = $1
        when /\AAllow:\s+(.+?)\s*(?:#.+)?\z/i
          @allow = $1
        end
      end

      def allow?
        @user_agent && @allow
      end

      def disallow?
        @user_agent && @disallow
      end

      private

      def clear_permissions
        @disallow = nil
        @allow = nil
      end
    end
  end
end
