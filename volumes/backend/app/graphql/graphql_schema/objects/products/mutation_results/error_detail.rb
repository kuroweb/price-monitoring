module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class ErrorDetail < Base
          field :field, String, null: false
          field :message, String, null: false
        end
      end
    end
  end
end
