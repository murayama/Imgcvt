# coding: utf-8

# オプションをパースして保持する

module Imgcvt
  class Options

    WIDTH_LIMIT = 2000
    HEIGHT_LIMIT = 2000
    DEFAULT_QUALITY = 80

    def initialize( params )
      @options = params
    end

    def width
      @options['w'].to_i > WIDTH_LIMIT ? WIDTH_LIMIT : @options['w'].to_i
    end

    def width=(val)
      @options['w'] = val 
    end

    def height
      @options['h'].to_i > HEIGHT_LIMIT ? HEIGHT_LIMIT : @options['h'].to_i
    end

    def height=(val)
      @options['h'] = val 
    end

    def copyright
      @options['cr'] == 'on' ? true : false
    end

    def quality
      @options['q'] ||= DEFAULT_QUALITY
      @options['q'].to_i
    end

    def crop
      @options['cc'] == 'on' ? true : false
    end
  end
end
