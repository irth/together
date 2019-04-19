# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[password]

# anonymize IPs
module Rails
  module Rack
    class Logger < ActiveSupport::LogSubscriber
      def started_request_message(request)
        format('Started %s "%s" for %s at %s', request.request_method, request.filtered_path, anonymized_ip(request), Time.now.to_default_s)
      end

      def anonymized_ip(request)
        ip = IPAddr.new(request.ip)

        if ip.ipv4?
          ip.mask(24).to_s
        else
          ip.mask(48).to_s
        end
      end
    end
  end
end
