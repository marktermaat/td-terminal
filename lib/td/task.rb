module Td
  class Task
    attr_accessor :id, :topic, :description

    def initialize(id, topic, description)
      @id = id
      @topic = topic
      @description = description
    end
  end
end