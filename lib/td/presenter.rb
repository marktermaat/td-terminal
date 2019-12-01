require 'pastel'

module Td
  class Presenter
    def initialize
      @pastel = Pastel.new
    end

    def present_tasks(tasks)
      Gem.win_platform? ? (system "cls") : (system "clear")
      tasks.group_by { |t| t.topic}.each do |topic, tasks|
        puts @pastel.bright_magenta.on_black(topic)
        tasks.each do |task|
          puts "#{@pastel.white.dim.on_black(task.id.to_s + '.')} #{@pastel.bright_white.on_black(task.description)}"
          task.notes.each_with_index do |note, index|
            puts "   #{@pastel.yellow.dim.on_black((index+1).to_s + '.')} #{@pastel.bright_yellow.dim.on_black(note)}"
          end
        end
        puts '' # Empty line
      end
    end
  end
end
