module GraphqlSchema
  module Objects
    module Products
      class ErrorDetail < Base
        field :field, String, null: false
        field :message, String, null: false
      end
    end
  end
end
