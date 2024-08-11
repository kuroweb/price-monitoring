module GraphqlSchema
  module Objects
    class ErrorDetailType < Base
      field :field, String, null: false
      field :message, String, null: false
    end
  end
end
