require_relative 'task'
require_relative 'command_error'

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

    def start_task(task_number)
      task = find_task(task_number)
      task.events << {'action' => 'start', 'timestamp' => Time.now.utc.to_s}
      update_and_show_tasks
    end

    def pause_task(task_number)
      task = find_task(task_number)
      task.events << {'action' => 'pause', 'timestamp' => Time.now.utc.to_s}
      update_and_show_tasks
    end

    def finish_task(task_number)
      task = find_task(task_number)
      task.events << {'action' => 'done', 'timestamp' => Time.now.utc.to_s}
      update_and_show_tasks
    end

    def add_task(topic, description)
      @tasks << Td::Task.new(nil, topic, description)
      sort_tasks
      update_and_show_tasks
    end

    def delete_task(task_number)
      if task_number.include?('.')
        task_number, note_number = task_number.split('.')
        task = find_task(task_number)
        task.notes.delete_at(note_number.to_i - 1)
      else
        task = find_task(task_number)
        @tasks.delete(task)
        sort_tasks
      end
      update_and_show_tasks
    end

    def edit_task(task_number, description)
      if task_number.include?('.')
        task_number, note_number = task_number.split('.')
        task = find_task(task_number)
        task.notes[note_number.to_i - 1] = description
      else
        task = find_task(task_number)
        task.description = description
      end
      update_and_show_tasks
    end

    def add_note(task_number, note)
      task = find_task(task_number)
      task.notes << note
      update_and_show_tasks
    end

    def get_started_task()
      @tasks.find {|t| t.doing?}
    end

    private
    def find_task(task_number)
      task = @tasks.find {|t| t.id.to_s == task_number.to_s}
      raise Td::CommandError.new "Task '#{task_number}' not found." if task.nil?
      task
    end

    def update_and_show_tasks
      @io.write_tasks(@tasks)
      list
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