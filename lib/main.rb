# coding: utf-8

module Imgcvt
  class Main 

    def initialize(options={})
      @img_dir = options[:img_dir] ||= './public/images/'
      @headers = options[:headers] ||= {}
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

      begin
        # ファイルが存在しなかったら404
        raise unless File.exist?(file_path)

        # ファイルに読み込み権限がなかったら404
        raise unless File.readable?(file_path)

        # jpgかgifじゃなかったら404
        ext = File.extname(file_path);
        raise unless /jpg|jpeg|gif/i =~ ext

        # オプションをセット
        options = Imgcvt::Options.new( params )

        # 画像のコンバーターを生成する
        converter = Imgcvt::Converter.new( file_path, options )

        # 画像変換の実行
        img = converter.execute

        # mime_typeを取得する
        content_type = converter.mime_type
        @headers.merge!( { "Content-Type" => content_type } )
        [200, @headers, [img]]
      rescue
        [404, {"Content-Type" =>"text/plain"}, ["404 Not Found"]]
      end

    end
  end
end
