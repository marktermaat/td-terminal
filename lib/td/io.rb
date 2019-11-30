require 'fileutils'
require 'json'

module Td
  class Io
    def initialize
      @file = File.join(ENV['HOME'], '.td', 'tasks.json')
      dir = File.dirname(@file)
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def read_tasks
      return [] unless File.file?(@file)
      id = 0
      content = JSON.parse(File.read(@file), symbolize_keys: true)
      content.map { |task| Td::Task.new(id += 1, task['topic'], task['description'], task['created_at'], task['notes']) }
    end

    def write_tasks(tasks)
      File.open(@file, 'w') do |file|
        file.write(tasks.map { |t| t.to_hash }.to_json)
      end
    end
  end
end