module GraphqlSchema
  module Mutations
    class Base < GraphQL::Schema::RelayClassicMutation
      argument_class Arguments::Base
      field_class Fields::Base
      input_object_class InputObjects::Base
      object_class Objects::Base
    end
  end
end
