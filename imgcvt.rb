# coding: utf-8

require 'rubygems'
require 'RMagick'

module Imgcvt
  $:.unshift(File.join(File.dirname(__FILE__),'lib'))
  autoload :Main, 'main'
  autoload :Options, 'options'
  autoload :Converter, 'converter'
end
