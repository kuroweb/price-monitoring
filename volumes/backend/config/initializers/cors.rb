Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # TODO: config gem で origins の中身を切り替えられるようにする
    # 開発環境は frontend を 8080 で公開しない。他環境の許可と、用途未確認の固定 IP は残す
    allowed_origins = ["10.15.100.217"]
    allowed_origins << "localhost:8080" unless Rails.env.development?
    origins(*allowed_origins)
    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
