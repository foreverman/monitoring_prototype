module Sample
  module Persistence

    def update_issue_count
      if monitor_config.issue
        monitor_config.issue.update_issue_count(self)
      end
    end

    def store
      if save
        "#{self.class}Daily".constantize.store(self)
        update_issue_count
      end
    end
  end
end
