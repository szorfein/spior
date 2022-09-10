module Spior
  module Service
    module_function

    def restart
      Service.stop
      Service.start
      Msg.p 'ip changed.'
    end
  end
end
