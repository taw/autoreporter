require "open3"
require "shellwords"

class Autoreporter
  def initialize(command)
    @command = command
    @output = nil
  end

  def run_command!
    @output, status = Open3.capture2e(@command.shelljoin)
  end

  def clear_terminal!
    # system("clear") doesn't clear scrollback buffer on iTerm2, we need to do this:
    puts "\e[H\e[J\e[3J"
  end

  def display_result!
    clear_terminal!
    puts @output
  end

  def wait_for_condition!
    sleep 60
  end

  def run!
    while true
      run_command!
      display_result!
      wait_for_condition!
    end
  end
end
