module Helpers
  class Exec
    def initialize(name)
      @search_uid=`id -u`.chomp
      @search_uid ||= 1000 unless $?.success?
      @name = name
    end

    def run(args)
      if @search_uid == '0' then
        #puts "found root - uid #{@search_uid}"
        system(@name + " " + args)
      else
        #puts "no root - call sudo - uid #{@search_uid}"
        system("sudo " + @name + " " + args)
      end
    end
  end
end
