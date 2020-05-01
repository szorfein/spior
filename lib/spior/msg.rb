require 'rainbow'

module Msg
  def self.head
    puts Rainbow("------------------------------------------------").cyan
  end

  def self.p(text)
    puts Rainbow("[").cyan + Rainbow("+").white + Rainbow("]").cyan + " " + text
  end

  def self.err(text)
    puts Rainbow("[").red + Rainbow("-").white + Rainbow("]").red + " " + text
  end
end
