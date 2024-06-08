module GraphqlSchema
  class Schema < GraphQL::Schema
    mutation(Objects::MutationType)
    query(Objects::QueryType)

    # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
    use GraphQL::Dataloader

    # GraphQL-Ruby calls this when something goes wrong while running a query:
    def self.type_error(err, context)
      # if err.is_a?(GraphQL::InvalidNullError)
      #   # report to your bug tracker here
      #   return nil
      # end
      super
    end

    # Union and Interface Resolution
    def self.resolve_type(_abstract_type, obj, _ctx)
      case obj
      when Product
        Objects::Products::ProductType
      else
        raise("Unexpected object: #{obj}")
      end
    end

    # Limit the size of incoming queries:
    max_query_string_tokens(5000)

    # Stop validating when it encounters this many errors:
    validate_max_errors(100)

    # Relay-style Object Identification:

    # Return a string UUID for `object`
    def self.id_from_object(object, _type_definition, _query_ctx)
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      object.to_gid_param
    end

    # Given a string UUID, find the object
    def self.object_from_id(global_id, _query_ctx)
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      GlobalID.find(global_id)
    end
  end
end
