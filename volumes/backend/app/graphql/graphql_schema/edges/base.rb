module GraphqlSchema
  module Edges
    class Base < Objects::Base
      # add `node` and `cursor` fields, as well as `node_type(...)` override
      include GraphQL::Types::Relay::EdgeBehaviors
    end
  end
end
