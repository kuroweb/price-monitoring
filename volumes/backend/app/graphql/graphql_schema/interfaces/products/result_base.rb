module GraphqlSchema
  module Interfaces
    module Products
      module ResultBase
        include Base

        field :ok, Boolean, null: false
      end
    end
  end
end
