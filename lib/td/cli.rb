require 'readline'

require_relative 'task_list'
require_relative 'io'
require_relative 'presenter'

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

        case command
        when 'h', 'help' then help
        when 'l', 'list' then list
        when 'a', 'add' then add(args)
        when 'd', 'del', 'delete' then delete(args)
        when 'e', 'edit' then edit(args)
        when 'q', 'quit', 'exit' then exit(0)
        end
      end
    end

    def help
      puts ' - l/list - List all tasks'
      puts ' - a/add @TOPIC TASK_DESCRIPTION - Add a new task'
      puts ' - d/del TASK_NUMBER - Deletes a task'
      puts ' - e/edit TASK_NUMBER TASK_DESCRIPTION - Edits a task'
    end

    def list
      @task_list.list
    end

    def add(args)
      if args.length < 1
        puts "Incorrect usage. Use 'a/add (@TOPIC) TASK_DESCRIPTION - Add a new task'"
        return
      end
      topic, *description = args
      unless topic.start_with?('@')
        description.unshift(topic)
        topic = nil
      end
      @task_list.add_task(topic, description.join(' '))
    end

    def delete(args)
      if args.length != 1
        puts "Incorrect usage. Use 'd/del TASK_NUMBER - Deletes a task'"
        return
      end
      @task_list.delete_task(args.first)
    end

    def edit(args)
      if args.length <= 1
        puts "Incorrect usage. Use 'e/edit TASK_NUMBER TASK_DESCRIPTION - Edits a task'"
        return
      end
      task_number, *description = args
      @task_list.edit_task(task_number, args.join(' '))
    end
  end
end