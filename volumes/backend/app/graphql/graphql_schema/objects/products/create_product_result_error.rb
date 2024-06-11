module GraphqlSchema
  module Objects
    module Products
      class CreateProductResultError < Base
        implements Interfaces::Products::ResultBase

        field :error, Unions::Products::CreateProductResultErrors, null: false
      end
    end
  end
end
