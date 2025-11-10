module Tempo
  class AttributeSyncService
    TARGET_KEYS = {
      "_Видработ_" => "work_kind",
      "_ЦC:действия_" => "cs_action",
      "_ЦC:ИС_" => "cs_is"
    }.freeze

    def initialize(client:)
      @client = client
    end

    def call
      payload = fetch_payload
      items = Array(payload)
      items.each do |item|
        category = TARGET_KEYS[item["key"]]
        next unless category

        upsert_values(item, category)
      end
    end

    private

    def fetch_payload
      response = @client.get("/rest/tempo-core/1/work-attribute")
      JSON.parse(response.body)
    end

    def upsert_values(item, category)
      values = Array(item["staticListValues"]).reject { |val| val["removed"] }
      current_ids = values.map { |val| val["id"] }

      values.each do |value|
        record = TempoWorkAttribute.find_or_initialize_by(external_id: value["id"])
        record.assign_attributes(
          name: value["name"],
          value: value["value"],
          key: item["key"],
          category: category,
          synced_at: Time.current
        )
        record.save!
      end

      TempoWorkAttribute.where(category:, key: item["key"]).where.not(external_id: current_ids).delete_all
    end
  end
end
