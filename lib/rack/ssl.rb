require 'rack'
require 'rack/request'

module Rack
  class SSL
    def initialize(app)
      @app = app
    end

    def call(env)
      if scheme(env) == 'https'
        status, headers, body = @app.call(env)
        headers = hsts_headers.merge(headers)
        [status, headers, body]
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
        [301, hsts_headers.merge({'Content-Type' => "text/html", 'Location' => location}), []]
      end

      # http://tools.ietf.org/html/draft-hodges-strict-transport-sec-02
      def hsts_headers
        { 'Strict-Transport-Security' => "max-age=16070400; includeSubDomains" }
      end
  end
end
