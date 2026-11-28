module Api
  module V1
    module ProductMonitoring
      # 計測から除外する出品者の登録と解除。登録はサイトと出品者IDの組で、同じ組は重ねて登録できない
      class ExcludedSellersController < Api::ApplicationController
        rescue_from ArgumentError, with: :invalid_excluded_seller

        def index
          render json: { excluded_sellers: ::ProductMonitoring::ExcludedSeller.order(id: :desc).as_json }, status: :ok
        end

        def create
          params = self.params.permit(:platform, :seller_id)
          excluded_seller = ::ProductMonitoring::ExcludedSeller::Writer.call(params:)
          render json: excluded_seller.as_json, status: :ok
        end

        # 収集結果は消していないので、解除すると次の表示・通知の評価から再び対象になる
        def destroy
          ::ProductMonitoring::ExcludedSeller.find(params.expect(:id)).destroy!
          render json: {}, status: :ok
        end

        private

        def invalid_excluded_seller(error)
          render json: build_error_json(400, error.message, []), status: :bad_request
        end
      end
    end
  end
end
