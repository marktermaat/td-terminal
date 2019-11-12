require_relative 'task'

module Td
  class TaskList
    def initialize(io, presenter)
      @io = io
      @presenter = presenter
      @tasks = @io.read_tasks
    end

    def list
      @presenter.present_tasks(@tasks)
    end

    def add_task(topic, description)
      @tasks << Td::Task.new(nil, topic, description)
      sort_tasks
      @io.write_tasks(@tasks)
      list
    end

    def delete_task(task_number)
      @tasks = @tasks.delete_if {|t| t.id.to_s == task_number.to_s}
      sort_tasks
      list
    end

    private
    def sort_tasks
      @tasks = @tasks
                   .group_by { |t| t.topic}
                   .sort_by { |topic, _| topic }
                   .map {|_topic, tasks| tasks }
                   .flatten
      @tasks.each_with_index { |task, index| task.id = index + 1 }
    end
  end
end