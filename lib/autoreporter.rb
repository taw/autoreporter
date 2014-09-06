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

  def display_result!
    print "\e[2J\e[f" # clear screen
    puts @output
  end

  def wait_for_condition!
    sleep 15
  end

  def run!
    while true
      run_command!
      display_result!
      wait_for_condition!
    end
  end
end
