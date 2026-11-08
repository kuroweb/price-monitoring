# OIDC の RP-Initiated Logout。Client のログアウト後にブラウザを移し、Provider のセッションも終了する
class EndSessionsController < ApplicationController
  def show
    application = application_from_id_token_hint
    # 第三者のリンクでログアウトさせられないよう、自分が発行した ID トークンがあるときだけ終了する
    return redirect_to(root_path) unless application

    sign_out(:user)
    redirect_uri = params[:post_logout_redirect_uri]
    if allowed_redirect_uri?(application, redirect_uri)
      redirect_to redirect_uri, allow_other_host: true
    else
      redirect_to new_user_session_path
    end
  end

  private

  def application_from_id_token_hint
    # ログアウトは ID トークンの期限後にも行われるため、有効期限は確かめない
    payload, = JWT.decode(
      params[:id_token_hint].to_s, nil, true,
      algorithms: [Doorkeeper::OpenidConnect.signing_algorithm.to_s],
      jwks: JWT::JWK::Set.new(Doorkeeper::OpenidConnect.signing_keys),
      verify_expiration: false,
      iss: Doorkeeper::OpenidConnect.resolve_issuer(request:), verify_iss: true
    )
    Doorkeeper::Application.find_by(uid: payload["aud"])
  rescue JWT::DecodeError
    nil
  end

  # 戻り先は、そのクライアントに登録したリダイレクト URI と同じオリジンに限る
  def allowed_redirect_uri?(application, redirect_uri)
    return false if redirect_uri.blank?

    origin = URI.parse(redirect_uri).origin
    application.redirect_uri.split.any? { |uri| URI.parse(uri).origin == origin }
  rescue URI::InvalidURIError, NoMethodError
    false
  end
end
