# coding: utf-8

require 'rubygems'
require 'RMagick'

module Imgcvt
  $LOAD_PATH << 'lib'
  autoload :Main, 'imgcvt/main'
  autoload :Options, 'imgcvt/options'
  autoload :Converter, 'imgcvt/converter'
end
