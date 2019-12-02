module Td
  class Task
    attr_accessor :id, :topic, :description, :notes, :created_at, :doing

    def initialize(id, topic, description, created_at = nil, notes = [], doing = false)
      @id = id
      @topic = topic
      @description = description
      @notes = notes
      @created_at = created_at || Time.now
      @doing = doing
    end

    def to_hash
      {topic: @topic, description: @description, notes: @notes, created_at: @created_at, doing: @doing}
    end
  end
end