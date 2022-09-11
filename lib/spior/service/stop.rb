module Spior
  module Service
    module_function

    def stop
      Tor.stop
      Clear.all
    end
  end
end
