# frozen_string_literal: true

require 'rainbow'

# Used to display various message
module Msg
  module_function

  def banner
    puts
    puts '┏━┓┏━┓╻┏━┓┏━┓'
    puts '┗━┓┣━┛┃┃ ┃┣┳┛'
    puts '┗━┛╹  ╹┗━┛╹┗╸'
    puts
    # generated with toilet -F crop -f future spior
  end

  def head
    puts Rainbow('------------------------------------------------').cyan
  end

  def p(text)
    opn = Rainbow('[').cyan
    msg = Rainbow('+').white
    cls = Rainbow(']').cyan
    puts "#{opn}#{msg}#{cls} #{text}"
  end

  def err(text)
    opn = Rainbow('[').red
    msg = Rainbow('-').white
    cls = Rainbow(']').red
    puts "#{opn}#{msg}#{cls} #{text}"
  end

  def info(text)
    one = Rainbow('_').blue
    two = Rainbow('-').white
    thr = Rainbow('_').blue
    puts "#{one}#{two}#{thr} #{text} #{one}#{two}#{thr}"
  end

  def report(text)
    puts
    info text
    puts 'Please, report this issue at https://github.com/szorfein/spior/issues'
    puts
    exit 1
  end
end
