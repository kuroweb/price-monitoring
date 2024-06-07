module GraphqlSchema
  module InputObjects
    class Base < GraphQL::Schema::InputObject
      argument_class Arguments::Base
    end
  end
end
