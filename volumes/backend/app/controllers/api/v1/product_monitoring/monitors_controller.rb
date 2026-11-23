module Api
  module V1
    module ProductMonitoring
      class MonitorsController < Api::ApplicationController
        PURCHASES_MAX_DAYS = 90
        HIDDEN_COLUMNS = %i[last_lowest_signature newest_notified_until].freeze

        rescue_from ArgumentError, with: :invalid_settings
        before_action :set_monitor,
                      only: %i[update destroy crawl_results summary aggregate_daily_market_prices transactions]

        def index
          render json: {
            monitors: ::ProductMonitoring::Monitor.order(id: :desc).as_json(except: HIDDEN_COLUMNS),
            discord_configured: ::ProductMonitoring::Notification::DiscordWebhook.configured?
          }, status: :ok
        end

        def create
          setting = ::ProductMonitoring::Monitor::Writer.call(monitor: ::ProductMonitoring::Monitor.new,
                                                              params: upsert_params)
          render json: setting.as_json(except: HIDDEN_COLUMNS), status: :ok
        end

        def update
          ::ProductMonitoring::Monitor::Writer.call(monitor: @monitor,
                                                    params: upsert_params)
          render json: @monitor.as_json(except: HIDDEN_COLUMNS), status: :ok
        end

        def destroy
          @monitor.destroy!
          render json: {}, status: :ok
        end

        # all=true は詳細向けに、抽出条件に合う保存済みを新着順ですべて返す。省略時は一覧の8件
        def crawl_results
          results = if ActiveModel::Type::Boolean.new.cast(params[:all])
                      ::ProductMonitoring::Search::MatchingCrawlResults.call(monitor: @monitor)
                    else
                      ::ProductMonitoring::Search::NewestCrawlResults.call(monitor: @monitor)
                    end
          render json: { crawl_results: results.as_json }, status: :ok
        end

        def summary
          lowest = ::ProductMonitoring::Search::LowestCrawlResults.call(monitor: @monitor).first
          latest = @monitor.daily_market_prices.where.not(average_transaction_price: nil).order(:date).last
          render json: { lowest_price: lowest&.price,
                         latest_average_transaction_price: latest&.average_transaction_price }, status: :ok
        end

        def aggregate_daily_market_prices
          end_date = Time.zone.today
          ::ProductMonitoring::Aggregation::AggregateDailyMarketPrices.call(
            monitor: @monitor, start_date: end_date - 29, end_date:
          )
          render json: {}, status: :ok
        end

        def transactions
          start_date = Date.parse(params.require(:start_date))
          end_date = Date.parse(params.require(:end_date))
          if end_date < start_date || (end_date - start_date).to_i >= PURCHASES_MAX_DAYS
            raise ArgumentError, "期間は開始日から#{PURCHASES_MAX_DAYS}日以内で指定してください"
          end

          results = ::ProductMonitoring::Aggregation::Transactions.call(
            monitor: @monitor, start_date:, end_date:
          )
          render json: { transactions: results.sort_by(&:sold_at).reverse.as_json }, status: :ok
        end

        private

        def upsert_params
          params.permit(:name, :enabled, :discord_enabled, :newest_notification_enabled, :min_price, :max_price,
                        required_keywords: [], negative_keywords: [])
        end

        def set_monitor
          @monitor = ::ProductMonitoring::Monitor.find(params.expect(:id))
        end

        def invalid_settings(error)
          render json: build_error_json(400, error.message, []), status: :bad_request
        end
      end
    end
  end
end
