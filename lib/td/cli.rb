require 'readline'

require_relative 'task_list'
require_relative 'io'
require_relative 'presenter'
require_relative 'command_error'

module Td
  class Cli
    PROMPT = '> '
    ADD_HIST = true

    def initialize()
      @io = Td::Io.new
      @presenter = Td::Presenter.new
      @task_list = Td::TaskList.new(@io, @presenter)
    end

    def start
      list
      while input = Readline.readline(PROMPT, ADD_HIST)
        command, *args = input.split(' ')
        next if command.empty?

        begin
          case command
          when 'h', 'help' then help
          when 'l', 'list' then list
          when 's', 'start' then start_task(args)
          when 'a', 'add' then add(args)
          when 'd', 'del', 'delete' then delete(args)
          when 'e', 'edit' then edit(args)
          when 'n', 'note' then note(args)
          when 'q', 'quit', 'exit' then exit(0)
          end
        rescue CommandError => e
          puts e.message
        end
      end
    end

    private

    def help
      puts ' - l/list - List all tasks'
      puts ' - s/start - Start a task'
      puts ' - a/add @TOPIC TASK_DESCRIPTION - Add a new task'
      puts ' - d/del TASK_NUMBER - Deletes a task'
      puts ' - e/edit TASK_NUMBER TASK_DESCRIPTION - Edits a task'
      puts ' - n/note TASK_NUMBER NOTE - Add a note to a task'
    end

    def list
      @task_list.list
    end

    def start_task(args)
      validate_args(args, 1, 1, "Incorrect usage. Use 's/start TASK_NUMBER'")
      task_number = args[0]
      @task_list.start_task(task_number)
    end

    def add(args)
      validate_args(args, 2, nil, "Incorrect usage. Use 'a/add (@TOPIC) TASK_DESCRIPTION'")
      topic, *description = args
      unless topic.start_with?('@')
        description.unshift(topic)
        topic = "@uncategorized"
      end
      @task_list.add_task(topic, description.join(' '))
    end

    def delete(args)
      validate_args(args, 1, 1, "Incorrect usage. Use 'd/del TASK_NUMBER'")
      @task_list.delete_task(args.first)
    end

    def edit(args)
      validate_args(args, 2, nil, "Incorrect usage. Use 'e/edit TASK_NUMBER TASK_DESCRIPTION'")
      task_number, *description = args
      @task_list.edit_task(task_number, description.join(' '))
    end

    def note(args)
      validate_args(args, 2, nil, "Incorrect usage. Use 'n/note TASK_NUMBER NOTE'")
      task_number, *note = args
      @task_list.add_note(task_number, note.join(' '))
    end

    def validate_args(args, min, max, usage)
      if args.length < min || (!max.nil? && args.length > max)
        raise Td::CommandError.new(usage)
      end
    end
  end
end