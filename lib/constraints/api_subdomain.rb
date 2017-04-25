module Constraints
  class ApiSubdomain

    def initialize(options={})
      # TODO: move to settings
      @test_hosts = options.fetch(:test_hosts, /devlits|ngrok/)
      @subdomain = options.fetch(:subdomain, 'api')
    end

    def matches?(request)
      if request.host =~ test_hosts
        request.subdomain.include?(subdomain)
      else
        request.subdomain == subdomain
      end
    end

    private
    attr_reader :subdomain, :test_hosts

  end
end
