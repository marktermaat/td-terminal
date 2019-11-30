module Td
  class Task
    attr_accessor :id, :topic, :description, :notes, :created_at

    def initialize(id, topic, description, created_at = nil, notes = [])
      @id = id
      @topic = topic
      @description = description
      @notes = notes
      @created_at = created_at || Time.now
    end

    def to_hash
      {topic: @topic, description: @description, notes: @notes, created_at: @created_at}
    end
  end
end