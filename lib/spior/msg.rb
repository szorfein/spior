# frozen_string_literal: true

require 'rainbow'

module Msg
  extend self

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
    puts Rainbow('-').blue + Rainbow('-').white + Rainbow('-').blue + ' ' + text + ' ' + Rainbow('-').blue + Rainbow('-').white + Rainbow('-').blue
  end

  def report(text)
    puts
    info text
    puts 'Please, report this issue at https://github.com/szorfein/spior/issues'
    puts
  end
end
