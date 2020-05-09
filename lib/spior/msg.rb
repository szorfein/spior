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

  def self.info(text)
    puts Rainbow("-").blue + Rainbow("-").white + Rainbow("-").blue + " " + text + " " + Rainbow("-").blue + Rainbow("-").white + Rainbow("-").blue
  end

  def self.report(text)
    puts ""
    info text
    puts "Please, report this issue at https://github.com/szorfein/spior/issues"
    puts ""
  end

  def self.for_no_systemd
    puts "Init system is not yet supported. You can contribute to add it."
  end
end
