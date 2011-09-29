class Issue
  include MongoMapper::Document
  
  belongs_to :monitor_config

  many :cases, :class_name => "IssueCase"

  def check(sample)
    cases.select {|ca| ca.check(sample)}.map(&:_id)
  end

  def update_issue_count(sample)
    case_ids = check(sample)
    return if case_ids.empty?

    inc = {
      'cases.$.current_issue_count' => 1
    }
    self.collection.update(
      {
        '_id' => self.id,
        'cases' => {
          '$elemMatch' => {'_id' => case_ids}  
        }
      },
      {'$inc' => inc},
      :multi => true
    )
  end
end
