require 'pastel'

module Td
  class Presenter
    def initialize
      @pastel = Pastel.new
    end

    def present_tasks(tasks)
      clear_line
      tasks.group_by(&:topic).each do |topic, topic_tasks|
        present_topic(topic)
        topic_tasks.each(&method(:present_task))
        puts ''
      end
    end

    private

    def clear_line
      Gem.win_platform? ? (system "cls") : (system "clear")
    end

    def present_topic(topic)
      puts @pastel.bright_magenta.on_black(topic)
    end

    def present_task(task)
      checkbox = task.doing? ? @pastel.bright_yellow.bold.on_black('[*]') : '[ ]'
      if task.done?
        puts "#{@pastel.white.dim.on_black(task.id.to_s + '.')} [X] #{@pastel.bright_white.strikethrough.on_black(task.description)}"
      else
        puts "#{@pastel.white.dim.on_black(task.id.to_s + '.')} #{checkbox} #{@pastel.bright_white.on_black(task.description)}"
      end

      task.notes.each_with_index do |note, index|
        puts "       #{@pastel.yellow.dim.on_black(task.id.to_s + '.' + (index+1).to_s + '.')} #{@pastel.bright_yellow.dim.on_black(note)}"
      end
    end
  end
end
