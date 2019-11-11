require 'pastel'

module Td
  class Presenter
    def initialize
      @pastel = Pastel.new
    end

    def present_tasks(tasks)
      tasks.group_by { |t| t.topic}.each do |topic, tasks|
        puts @pastel.bright_magenta.on_black(topic)
        tasks.each do |task|
          puts "- [#{task.id}] #{@pastel.bright_white.on_black(task.description)}"
        end
      end
    end
  end
end
