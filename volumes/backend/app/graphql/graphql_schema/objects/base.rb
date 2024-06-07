module GraphqlSchema
  module Objects
    class Base < GraphQL::Schema::Object
      edge_type_class(Edges::Base)
      connection_type_class(Connections::Base)
      field_class Fields::Base
    end
  end
end
