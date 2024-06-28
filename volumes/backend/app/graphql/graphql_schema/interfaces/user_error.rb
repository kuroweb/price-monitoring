module GraphqlSchema
  module Interfaces
    module UserError
      include Base

      field :code, String, null: false
      field :message, String, null: false
    end
  end
end
