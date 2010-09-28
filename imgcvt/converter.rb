# coding: utf-8

# 画像を変換する

module Imgcvt
  class Converter

    COPYRIGHT_PROTECTION_COMMENT = 'kddi_copyright=on,copy="NO"'

    def initialize( file_path, options )
      # イメージを読み込む
      @image = Magick::Image.read(file_path).first
      @options = options
    end

    def execute

      if @options.width > 0 || @options.height > 0

        # heightだけ指定された場合は、元画像の比率を計算してwidthを取得する
        if @options.width == 0
          @options.width = @options.height * (@image.columns.to_f / @image.rows.to_f)
        end
        # widthだけ指定された場合は、元画像の比率を計算してheightを取得する
        if @options.height == 0
          @options.height = @options.width * (@image.rows.to_f / @image.columns.to_f)
        end

        cvt_image = @image.send( convert_method, @options.width, @options.height )

      else
        # widthとheightの両方が指定されていない場合はサイズの変換は行わない
        cvt_image = @image
      end

      # 著作権保護コメントの埋め込み
      cvt_image[:Comment] = COPYRIGHT_PROTECTION_COMMENT if copyright_protection?

      quality = @options.quality
      return cvt_image.to_blob { self.quality = quality }

    end

    def mime_type
      @image.mime_type
    end

    private
    def convert_method
      if @options.crop
        method = :resize_to_fill
      else
        method = :resize_to_fit
      end
    end

    def copyright_protection?
      @options.copyright
    end

  end
end
