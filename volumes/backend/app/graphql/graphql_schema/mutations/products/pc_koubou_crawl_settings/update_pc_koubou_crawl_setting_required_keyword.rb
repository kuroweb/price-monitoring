module GraphqlSchema
  module Mutations
    module Products
      module PcKoubouCrawlSettings
        class UpdatePcKoubouCrawlSettingRequiredKeyword < Base
          input_object_class InputObjects::Products::PcKoubouCrawlSettings::
                             UpdatePcKoubouCrawlSettingRequiredKeywordInput

          type Unions::Products::PcKoubouCrawlSettings::UpdatePcKoubouCrawlSettingRequiredKeyword::
               UpdatePcKoubouCrawlSettingRequiredKeywordResult, null: false

          def resolve(input)
            product = Product.find(input[:product_id])
            pc_koubou_crawl_setting_required_keyword =
              product
              .pc_koubou_crawl_setting
              .pc_koubou_crawl_setting_required_keywords
              .find(input[:id])
            pc_koubou_crawl_setting_required_keyword.update!(keyword: input[:keyword])

            inspect(product)

            {
              __typename: "UpdatePcKoubouCrawlSettingRequiredKeywordResultSuccessType",
              pc_koubou_crawl_setting_required_keyword:,
              ok: true
            }
          rescue StandardError => e
            handle_error(e)
          end

          private

          def inspect(product)
            ::Products::Inspector::InspectPcKoubouProducts.call(product:)
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
              __typename: "UpdatePcKoubouCrawlSettingRequiredKeywordResultErrorType",
              error: {
                __typename: "UpdatePcKoubouCrawlSettingRequiredKeywordResultValidationFailedType",
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
