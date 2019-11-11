require 'fileutils'

module Td
  class Io
    def initialize
      @file = File.join(ENV['HOME'], '.td', 'tasks')
      dir = File.dirname(@file)
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def read_tasks
      return [] unless File.file?(@file)
      id = 0
      File.readlines(@file).map do |line|
        elems = line.split(' ')
        if elems[0].start_with?('@')
          Td::Task.new(id += 1, elems[0], elems[1..-1].join(' '))
        else
          Td::Task.new(id += 1, nil, elems.join(' '))
        end
      end
    end

    def write_tasks(tasks)
      File.open(@file, 'w') do |file|
        tasks.each do |task|
          file.puts "#{task.topic} #{task.description}"
        end
      end
    end
  end
end