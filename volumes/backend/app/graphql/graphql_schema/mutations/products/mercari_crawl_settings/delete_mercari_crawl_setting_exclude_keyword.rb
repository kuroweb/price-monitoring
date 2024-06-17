module GraphqlSchema
  module Mutations
    module Products
      module MercariCrawlSettings
        class DeleteMercariCrawlSettingExcludeKeyword < Base
          input_object_class InputObjects::Products::MercariCrawlSettings::
                             DeleteMercariCrawlSettingExcludeKeywordInput

          type Unions::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
               DeleteMercariCrawlSettingExcludeKeywordResult, null: false

          def resolve(input) # rubocop:disable Metrics/MethodLength
            product = Product.find(input[:product_id])
            mercari_crawl_setting_exclude_keyword =
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_exclude_keywords
              .find(input[:id])

            if mercari_crawl_setting_exclude_keyword.destroy
              {
                __typename: "DeleteMercariCrawlSettingExcludeKeywordResultSuccess",
                mercari_crawl_setting_exclude_keyword:,
                ok: true
              }
            else
              error_response("400", "Bad Request.")
            end
          rescue StandardError => e
            handle_error(e)
          end

          private

          def handle_error(exception)
            case exception
            when ActiveRecord::RecordNotFound
              error_response("404", "Not Found.")
            else
              Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
              error_response("503", "Internal Server Error.")
            end
          end

          def error_response(code, message)
            {
              __typename: "DeleteMercariCrawlSettingExcludeKeywordResultError",
              error: {
                __typename: "DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed",
                code:,
                message:,
                details: []
              },
              ok: false
            }
          end
        end
      end
    end
  end
end
