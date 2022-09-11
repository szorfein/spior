# frozen_string_literal: true

module Spior

  # Service should start/stop/restart Tor and Iptable.
  module Service
  end
end

require_relative 'service/start'
require_relative 'service/stop'
require_relative 'service/restart'
