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
      task = find_task(task_number)
      @tasks.delete(task)
      sort_tasks
      @io.write_tasks(@tasks)
      list
    end

    def edit_task(task_number, description)
      task = find_task(task_number)
      task.description = description
      @io.write_tasks(@tasks)
      list
    end

    def add_note(task_number, note)
      task = find_task(task_number)
      if task.nil?
        puts "Task '#{task_number}' not found."
        return
      end
      task.notes << note
      @io.write_tasks(@tasks)
      list
    end

    private
    def find_task(task_number)
      @tasks.find {|t| t.id.to_s == task_number.to_s}
    end

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