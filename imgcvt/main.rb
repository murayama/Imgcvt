# coding: utf-8

module Imgcvt
  class Main 

    def initialize(options={})
      @img_dir = options[:img_dir] ||= './public/images/'
    end

    def call(env)
      req = Rack::Request.new(env)
      req.path_info =~ /(?:.*)\/(.*)$/
      file_path = File.join(@img_dir,$1)
      response( file_path, req.params )
    end

    def response( file_path, params )
      # キャッシュは外部に任せる
      # Rack::CacheとかApacheのmod_cacheとか

      # ファイルが存在しなかったら404
      return [404, {"Content-Type", "text/plain"}, ["404 Not Found"]] unless File.exist?(file_path)

      # jpgかgifじゃなかったら404
      ext = File.extname(file_path);
      return [404, {"Content-Type", "text/plain"}, ["404 Not Found"]] unless /jpg|jpeg|gif/i =~ ext

      # オプションをセット
      options = Imgcvt::Options.new( params )

      # 画像のコンバーターを生成する
      converter = Imgcvt::Converter.new( file_path, options )

      # 画像変換の実行
      img = converter.execute

      # mime_typeを取得する
      content_type = converter.mime_type
      [200, {"Content-Type", content_type}, [img]]
    end
  end
end
