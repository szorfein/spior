# frozen_string_literal: true

module Spior
  module Clear
    extend self

    def all
      rules = Iptables::Rules.new
      rules.restore
    end
  end
end
