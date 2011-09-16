module Sample

  def self.from_http params, body_hash
    Webpage.from_http(params, body_hash['webpage'])
  end
end
