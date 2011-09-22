module Sample

  class SampleTypeError < StandardError;end
  TYPES = %w{http webpage error}

  def self.from_http params, body_hash
    types = body_hash['messageTypes'] || [body_hash.keys.first]

    types.inject([]) do |samples, type|
      raise SampleTypeError, "Received unknown sample type #{type}" unless TYPES.include?(type)
      msg = body_hash[type]
      samples << "Sample::#{type.classify}".constantize.from_http(params, msg)
    end
  end
end
