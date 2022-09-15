# frozen_string_literal: true

require 'rainbow'

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
    puts Rainbow('[').cyan + Rainbow('+').white + Rainbow(']').cyan + ' ' + text
  end

  def err(text)
    puts Rainbow('[').red + Rainbow('-').white + Rainbow(']').red + ' ' + text
  end

  def info(text)
    print Rainbow('-').blue + Rainbow('-').white + Rainbow('-').blue
    print " #{text} "
    print Rainbow('-').blue + Rainbow('-').white + Rainbow('-').blue + "\n"
  end

  def report(text)
    puts
    info text
    puts 'Please, report this issue at https://github.com/szorfein/spior/issues'
    puts
    exit 1
  end
end
