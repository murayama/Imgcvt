# coding: utf-8

# 画像変換Rackアプリケーション
# 画像変換をしてレスポンスを返す
# 指定以外のディレクトリの場合はスルーする
# クエリパラメーターで指定された条件で画像を変換する
#
# Use Example:
# 以下の用にmapを使用する
# mapで指定するディレクトリは実在するディレクトリではなくても構わない
# 元画像の場所を指定することもできる。デフォルトは'./public/images/'
#
#  map '/image' do
#   run Imgcvt::Main.new
#  end
#
# Request Example
#   w  width pxで指定
#   h  height pxで指定
#   cc センタークロップ onで指定
#   cr ドコモとauの著作権保護コメントを埋め込む onで指定
#   q  jpeg画像のクオリティ 1〜100で指定
#
#   http://hoge.com/image/example.jpg?w=150&h=100
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
