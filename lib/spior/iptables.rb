# frozen_string_literal: true

module Spior
  # Interact with iptables
  module Iptables
  end
end

require_relative 'iptables/root'
require_relative 'iptables/tor'
require_relative 'iptables/default'
require_relative 'iptables/rules'
