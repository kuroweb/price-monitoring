module GraphqlSchema
  module Mutations
    module Products
      module PcKoubouCrawlSettings
        class DeletePcKoubouCrawlSettingRequiredKeyword < Base
          input_object_class InputObjects::Products::PcKoubouCrawlSettings::
                             DeletePcKoubouCrawlSettingRequiredKeywordInput

          field :result,
                Unions::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
                DeletePcKoubouCrawlSettingRequiredKeywordResult,
                null: false

          type Unions::Products::PcKoubouCrawlSettings::DeletePcKoubouCrawlSettingRequiredKeyword::
               DeletePcKoubouCrawlSettingRequiredKeywordResult

          def resolve(input) # rubocop:disable Metrics/MethodLength
            product = Product.find(input[:product_id])
            pc_koubou_crawl_setting_required_keyword =
              product
              .pc_koubou_crawl_setting
              .pc_koubou_crawl_setting_required_keywords
              .find(input[:id])

            if pc_koubou_crawl_setting_required_keyword.destroy
              {
                __typename: "DeletePcKoubouCrawlSettingRequiredKeywordResultSuccess",
                pc_koubou_crawl_setting_required_keyword:,
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
              __typename: "DeletePcKoubouCrawlSettingRequiredKeywordResultError",
              error: {
                __typename: "DeletePcKoubouCrawlSettingRequiredKeywordResultValidationFailed",
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
