class DashboardController < ApplicationController
  def index
    # 常にログイン画面にリダイレクト
    # TODO: 将来的にダッシュボード画面を実装
    # - アカウント情報
    # - 連携アプリ一覧
    # - セキュリティ設定
    # - ログイン履歴
    redirect_to new_user_session_path
  end
end
