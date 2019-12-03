module Td
  class Task
    attr_accessor :id, :topic, :description, :notes, :created_at, :events

    def initialize(id, topic, description, created_at = nil, notes = [], events = [])
      @id = id
      @topic = topic
      @description = description
      @notes = notes
      @created_at = created_at || Time.now
      @events = events || []
    end

    def to_hash
      {topic: @topic, description: @description, notes: @notes, created_at: @created_at, events: @events}
    end

    def doing?
      last_event = events.last
      return false if last_event.nil?
      return last_event['action'] == 'start'
    end
  end
end