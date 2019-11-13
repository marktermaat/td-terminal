require 'thor'
require_relative 'task_list'
require_relative 'io'
require_relative 'presenter'
# TODO: Initialize task_list with IO

module Td
  class Cli < Thor
    def initialize(*args)
      super
      @io = Td::Io.new
      @presenter = Td::Presenter.new
      @task_list = Td::TaskList.new(@io, @presenter)
    end

    desc "list", "list all tasks"
    method_options aliases: :l
    def list
      @task_list.list
    end

    desc "add @TOPIC TASK_DESCRIPTION", "add a new task"
    method_options aliases: :a
    def add(topic, *args)
      unless topic.start_with?('@')
        args.unshift(topic)
        topic = nil
      end
      @task_list.add_task(topic, args.join(' '))
    end

    desc "del TASK_NUMBER", "delete a task"
    method_options aliases: [:d, :delete]
    def delete(task_number)
      @task_list.delete_task(task_number)
    end

    desc "edit TASK_NUMBER TASK_DESCRIPTION", "edit a task"
    method_options aliases: :e
    def edit(task_number, *args)
      @task_list.edit_task(task_number, args.join(' '))
    end
  end
end