module Constraints
  class ApiVersion
    def initialize(options={})
      @version = options.fetch(:version)
      @default = options.fetch(:default, false)
    end

    def matches?(request)
      @default || check_headers(request.headers)
    end

    private
    attr_accessor :version, :default

    def check_headers(headers)
      accept = headers['X-API-Version']
      accept && accept.include?("api.#{@version}")
    end
  end
end