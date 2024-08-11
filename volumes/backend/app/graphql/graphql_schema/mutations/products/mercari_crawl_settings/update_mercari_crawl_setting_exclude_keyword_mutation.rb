module GraphqlSchema
  module Mutations
    module Products
      module MercariCrawlSettings
        class UpdateMercariCrawlSettingExcludeKeywordMutation < Base
          input_object_class InputObjects::Products::MercariCrawlSettings::
                             UpdateMercariCrawlSettingExcludeKeywordInput

          type Unions::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
               UpdateMercariCrawlSettingExcludeKeywordResult, null: false

          def resolve(input)
            product = Product.find(input[:product_id])
            mercari_crawl_setting_exclude_keyword =
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_exclude_keywords
              .find(input[:id])
            mercari_crawl_setting_exclude_keyword.update!(keyword: input[:keyword])

            inspect(product)

            {
              __typename: "UpdateMercariCrawlSettingExcludeKeywordResultSuccessType",
              mercari_crawl_setting_exclude_keyword:,
              ok: true
            }
          rescue StandardError => e
            handle_error(e)
          end

          private

          def inspect(product)
            ::Products::Inspect::DeleteMercariProducts.call(product:)
            ::Products::Inspect::DeleteYahooFleamarketProducts.call(product:)
          end

          def handle_error(exception)
            case exception
            when ActiveRecord::RecordInvalid
              Rails.logger.error("Bad Request. exception: #{exception.full_message}")
              error_response("400", "Bad Request.")
            when ActiveRecord::RecordNotFound
              error_response("404", "Not Found.")
            when ActiveRecord::RecordNotUnique
              error_response("409", "Conflict.")
            else
              Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
              error_response("503", "Internal Server Error.")
            end
          end

          def error_response(code, message)
            {
              __typename: "UpdateMercariCrawlSettingExcludeKeywordResultErrorType",
              error: {
                __typename: "UpdateMercariCrawlSettingExcludeKeywordResultValidationFailedType",
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
