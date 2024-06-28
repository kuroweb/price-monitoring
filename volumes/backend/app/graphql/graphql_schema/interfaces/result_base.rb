module GraphqlSchema
  module Interfaces
    module ResultBase
      include Base

      field :ok, Boolean, null: false
    end
  end
end
