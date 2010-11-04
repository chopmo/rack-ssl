require 'rack'
require 'rack/request'

module Rack
  class SSL
    def initialize(app)
      @app = app
    end

    def call(env)
      if scheme(env) == 'https'
        @app.call(env)
      else
        redirect_to_https(env)
      end
    end

    private
      # Fixed in rack >= 1.3
      def scheme(env)
        if env['HTTPS'] == 'on'
          'https'
        elsif env['HTTP_X_FORWARDED_PROTO']
          env['HTTP_X_FORWARDED_PROTO'].split(',')[0]
        else
          env['rack.url_scheme']
        end
      end

      def redirect_to_https(env)
        req      = Request.new(env)
        location = req.url.sub(/^http:/, 'https:')
        [301, {'Content-Type' => "text/html", 'Location' => location}, []]
      end
  end
end
