class IssueCase
  include MongoMapper::EmbeddedDocument

  key :metric # connection time_to_title
  key :action # > < =
  key :target # 500ms

  key :category #eg. reachability http_response page_load asset_load

  key :count_to_be_error, Integer, :default => 3

  key :current_issue_count, Integer

  #TODO check sample if meet it
  def check(sample)
    sample.send(metric).send(action, target)
  end
end
