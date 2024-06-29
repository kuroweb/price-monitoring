module GraphqlSchema
  module Mutations
    module Products
      module UsedSofmapCrawlSettings
        class DeleteUsedSofmapCrawlSettingExcludeKeyword < Base
          input_object_class InputObjects::Products::UsedSofmapCrawlSettings::
                             DeleteUsedSofmapCrawlSettingExcludeKeywordInput

          type Unions::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
               DeleteUsedSofmapCrawlSettingExcludeKeywordResult, null: false

          def resolve(input) # rubocop:disable Metrics/MethodLength
            product = Product.find(input[:product_id])
            used_sofmap_crawl_setting_exclude_keyword =
              product
              .used_sofmap_crawl_setting
              .used_sofmap_crawl_setting_exclude_keywords
              .find(input[:id])

            if used_sofmap_crawl_setting_exclude_keyword.destroy
              {
                __typename: "DeleteUsedSofmapCrawlSettingExcludeKeywordResultSuccess",
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
              __typename: "DeleteUsedSofmapCrawlSettingExcludeKeywordResultError",
              error: {
                __typename: "DeleteUsedSofmapCrawlSettingExcludeKeywordResultValidationFailed",
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
