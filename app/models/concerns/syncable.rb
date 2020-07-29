module Syncable
  extend ActiveSupport::Concern

  included do
    def self.sync_all(records)
      self.upsert_all records, unique_by: [:external_id]
    end

    def self.sync(record)
      self.upsert record, unique_by: [:external_id]
    end
  end
end
